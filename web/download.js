/**
 * 下载落地页逻辑 — 与 chat.html 同级部署在站点根目录 /download.html
 * 版本接口：GET {origin}/api/v1/app/versions/latest（对齐 template-api V1AppController#getLatestAppVersion）
 */
(function () {
  var VERSION_PATH = '/api/v1/app/versions/latest';
  var LANG_STORAGE_KEY = 'template_download_lang';
  // 与 App API_BACKUP_HOSTS 对齐；当前页域名优先，失败再试备用
  var BACKUP_ORIGINS = ['https://app.template.com', 'https://template.com'];

  var MESSAGES = {
    zh: {
      pageTitle: 'Flutter template App 下载',
      metaDescription: 'Flutter template App 官方下载',
      langSwitchAria: '切换语言',
      langCode: 'EN',
      logoAlt: 'Flutter template',
      appName: 'Flutter template',
      appTagline: '安全稳健 · 一站式管理平台',
      releaseNotes: '更新说明',
      recommended: '推荐',
      btnIosSmall: 'App Store / 企业签',
      btnIosLabel: 'iPhone 下载',
      btnAndroidSmall: 'Android APK',
      btnAndroidLabel: 'Android 下载',
      loadingVersion: '正在获取最新版本…',
      feature1: '银行级<br>安全保障',
      feature2: '多元投资<br>一站管理',
      feature3: '7×24<br>在线客服',
      featuresAriaLabel: '产品亮点',
      footerLine1: '© Flutter template · 官方客户端下载页',
      footerLine2: '请通过官方渠道安装，谨防仿冒应用',
      errorDefault: '版本信息加载失败，请稍后重试。',
      retry: '点击重试',
      latestVersion: '最新版本 v{version}',
      defaultDescription: '欢迎下载Flutter template App，体验安全便捷的财富管理服务。',
      iosRecommended: '检测到 iOS 设备，推荐上方 iPhone 下载。',
      iosNoUrl: '暂未配置 iOS 下载地址，请联系客服。',
      androidRecommended: '检测到 Android 设备，推荐上方 Android 下载。',
      androidNoUrl: '暂未配置 Android 下载地址，请联系客服。',
      otherPlatform: '请根据您的手机系统选择对应下载方式。',
      noDownloadLinks: '当前暂无可用下载链接，请稍后再试。',
      fetchErrorDesc: '暂时无法获取更新说明，您仍可尝试点击下方按钮下载（若已配置）。',
      fetchError: '版本信息加载失败：{message}',
      networkRetryHint: '请检查网络后重试，或联系官方客服获取安装包。',
      networkError: '网络异常',
      allApisFailed: '所有接口均不可用'
    },
    en: {
      pageTitle: 'Flutter template App Download',
      metaDescription: 'Official download page for the Flutter template App',
      langSwitchAria: 'Switch language',
      langCode: '中',
      logoAlt: 'Flutter template Financial',
      appName: 'Flutter template Financial',
      appTagline: 'Secure & steady · All-in-one wealth management',
      releaseNotes: 'Release Notes',
      recommended: 'Recommended',
      btnIosSmall: 'App Store / Enterprise',
      btnIosLabel: 'Download for iPhone',
      btnAndroidSmall: 'Android APK',
      btnAndroidLabel: 'Download for Android',
      loadingVersion: 'Fetching the latest version…',
      feature1: 'Bank-grade<br>security',
      feature2: 'Diversified<br>investments',
      feature3: '24/7<br>support',
      featuresAriaLabel: 'Highlights',
      footerLine1: '© Flutter template · Official download page',
      footerLine2: 'Install only from official channels. Beware of fake apps.',
      errorDefault: 'Failed to load version info. Please try again later.',
      retry: 'Retry',
      latestVersion: 'Latest v{version}',
      defaultDescription: 'Download the Flutter template App for secure and convenient wealth management.',
      iosRecommended: 'iOS device detected. We recommend the iPhone download above.',
      iosNoUrl: 'iOS download link is not configured yet. Please contact support.',
      androidRecommended: 'Android device detected. We recommend the Android download above.',
      androidNoUrl: 'Android download link is not configured yet. Please contact support.',
      otherPlatform: 'Choose the download option that matches your device.',
      noDownloadLinks: 'No download links are available right now. Please try again later.',
      fetchErrorDesc: 'Release notes are temporarily unavailable. You may still try the buttons below if links are configured.',
      fetchError: 'Failed to load version info: {message}',
      networkRetryHint: 'Check your network and retry, or contact official support for the installer.',
      networkError: 'Network error',
      allApisFailed: 'All API endpoints are unavailable'
    }
  };

  var currentLang = 'zh';
  var lastVersionData = null;
  var lastFetchError = null;
  var isLoading = false;

  var versionPill;
  var versionText;
  var descLoading;
  var descText;
  var btnIos;
  var btnAndroid;
  var iosWrap;
  var androidWrap;
  var platformHint;
  var errorBox;
  var errorText;
  var retryBtn;
  var langSwitch;
  var langCodeEl;
  var featuresSection;
  var metaDescription;

  function resolveLang() {
    var params = new URLSearchParams(window.location.search);
    var queryLang = (params.get('lang') || '').toLowerCase();
    if (queryLang === 'en' || queryLang === 'zh') {
      return queryLang;
    }
    try {
      var stored = localStorage.getItem(LANG_STORAGE_KEY);
      if (stored === 'en' || stored === 'zh') {
        return stored;
      }
    } catch (e) {
      // localStorage 不可用时保持默认中文
    }
    return 'zh';
  }

  function format(template, vars) {
    return template.replace(/\{(\w+)\}/g, function (_, key) {
      return vars && vars[key] != null ? vars[key] : '';
    });
  }

  function t(key, vars) {
    var pack = MESSAGES[currentLang] || MESSAGES.zh;
    var fallback = MESSAGES.zh[key] || key;
    return format(pack[key] != null ? pack[key] : fallback, vars);
  }

  function applyStaticI18n() {
    document.documentElement.lang = currentLang === 'zh' ? 'zh-CN' : 'en';
    document.title = t('pageTitle');
    if (metaDescription) {
      metaDescription.setAttribute('content', t('metaDescription'));
    }
    if (langSwitch) {
      langSwitch.setAttribute('aria-label', t('langSwitchAria'));
    }
    if (langCodeEl) {
      langCodeEl.textContent = t('langCode');
    }
    if (featuresSection) {
      featuresSection.setAttribute('aria-label', t('featuresAriaLabel'));
    }

    document.querySelectorAll('[data-i18n]').forEach(function (el) {
      var key = el.getAttribute('data-i18n');
      if (key) el.textContent = t(key);
    });

    document.querySelectorAll('[data-i18n-html]').forEach(function (el) {
      var key = el.getAttribute('data-i18n-html');
      if (key) el.innerHTML = t(key);
    });

    document.querySelectorAll('[data-i18n-attr]').forEach(function (el) {
      var spec = el.getAttribute('data-i18n-attr');
      if (!spec) return;
      spec.split(';').forEach(function (pair) {
        var parts = pair.split(':');
        if (parts.length === 2) {
          el.setAttribute(parts[0].trim(), t(parts[1].trim()));
        }
      });
    });
  }

  function setLang(lang) {
    if (lang !== 'zh' && lang !== 'en') return;
    currentLang = lang;
    try {
      localStorage.setItem(LANG_STORAGE_KEY, lang);
    } catch (e) {
      // ignore
    }
    applyStaticI18n();
    refreshDynamicTexts();
  }

  function toggleLang() {
    setLang(currentLang === 'zh' ? 'en' : 'zh');
  }

  // 1. 组装候选 API 地址：?api= 覆盖 > 当前域名 > 备用域名
  function buildVersionApiUrls() {
    var params = new URLSearchParams(window.location.search);
    var override = (params.get('api') || '').replace(/\/+$/, '');
    if (override) {
      return [override + VERSION_PATH];
    }

    var origins = [window.location.origin].concat(BACKUP_ORIGINS);
    var seen = {};
    var urls = [];

    origins.forEach(function (origin) {
      if (!origin || seen[origin]) return;
      seen[origin] = true;
      urls.push(origin.replace(/\/+$/, '') + VERSION_PATH);
    });

    return urls;
  }

  // 2. 依次请求候选地址，首个 code===0 且含 data 的响应即成功
  function fetchLatestVersion() {
    var urls = buildVersionApiUrls();
    var index = 0;

    function tryNext() {
      if (index >= urls.length) {
        return Promise.reject(new Error(t('allApisFailed')));
      }

      var url = urls[index++];
      return fetch(url, {
        method: 'GET',
        headers: { Accept: 'application/json' },
        cache: 'no-store',
        mode: 'cors',
        credentials: 'omit'
      })
        .then(function (res) {
          if (!res.ok) throw new Error('HTTP ' + res.status + ' @ ' + url);
          return res.json().then(function (body) {
            if (!body || body.code !== 0 || !body.data) {
              throw new Error((body && body.msg) || 'API error @ ' + url);
            }
            return body;
          });
        })
        .catch(function (err) {
          if (index < urls.length) return tryNext();
          throw err;
        });
    }

    return tryNext();
  }

  function detectPlatform() {
    var ua = navigator.userAgent || '';
    if (/iPhone|iPad|iPod/i.test(ua)) return 'ios';
    if (/Android/i.test(ua)) return 'android';
    return 'other';
  }

  function setRecommended(platform) {
    iosWrap.classList.toggle('is-recommended', platform === 'ios');
    androidWrap.classList.toggle('is-recommended', platform === 'android');
  }

  function enableButton(el, url) {
    if (!url) return;
    el.href = url;
    el.classList.remove('is-disabled');
    el.removeAttribute('aria-disabled');
  }

  function disableButtons() {
    btnIos.classList.add('is-disabled');
    btnAndroid.classList.add('is-disabled');
    btnIos.href = '#';
    btnAndroid.href = '#';
    btnIos.setAttribute('aria-disabled', 'true');
    btnAndroid.setAttribute('aria-disabled', 'true');
  }

  function showError(message) {
    errorText.textContent = message;
    errorBox.classList.add('show');
  }

  function hideError() {
    errorBox.classList.remove('show');
  }

  function renderPlatformHint(data) {
    var iosUrl = data.iosUrl || data.ios_url || '';
    var androidUrl = data.downloadUrl || data.download_url || '';
    var platform = detectPlatform();
    setRecommended(platform);

    if (platform === 'ios') {
      platformHint.textContent = iosUrl ? t('iosRecommended') : t('iosNoUrl');
    } else if (platform === 'android') {
      platformHint.textContent = androidUrl ? t('androidRecommended') : t('androidNoUrl');
    } else {
      platformHint.textContent = t('otherPlatform');
    }
  }

  function renderSuccessState(data) {
    var version = data.version || '';
    var description = data.description || t('defaultDescription');
    var androidUrl = data.downloadUrl || data.download_url || '';
    var iosUrl = data.iosUrl || data.ios_url || '';

    if (version) {
      versionText.textContent = t('latestVersion', { version: version });
      versionPill.hidden = false;
    } else {
      versionPill.hidden = true;
    }

    descLoading.hidden = true;
    descText.hidden = false;
    descText.textContent = description;

    disableButtons();
    if (iosUrl) enableButton(btnIos, iosUrl);
    if (androidUrl) enableButton(btnAndroid, androidUrl);

    renderPlatformHint(data);

    if (!iosUrl && !androidUrl) {
      showError(t('noDownloadLinks'));
    } else {
      hideError();
    }
  }

  function renderErrorState(err) {
    var message = err && err.message ? err.message : t('networkError');
    descLoading.hidden = true;
    descText.hidden = false;
    descText.textContent = t('fetchErrorDesc');
    showError(t('fetchError', { message: message }));
    platformHint.textContent = t('networkRetryHint');
  }

  function refreshDynamicTexts() {
    if (isLoading) {
      platformHint.textContent = t('loadingVersion');
      return;
    }
    if (lastFetchError) {
      renderErrorState(lastFetchError);
      return;
    }
    if (lastVersionData) {
      renderSuccessState(lastVersionData);
    }
  }

  // 3. 拉取最新版本并渲染下载链接
  function loadVersion() {
    isLoading = true;
    lastFetchError = null;
    hideError();
    platformHint.textContent = t('loadingVersion');
    disableButtons();
    descLoading.hidden = false;
    descText.hidden = true;

    fetchLatestVersion()
      .then(function (body) {
        lastVersionData = body.data;
        lastFetchError = null;
        renderSuccessState(lastVersionData);
      })
      .catch(function (err) {
        lastVersionData = null;
        lastFetchError = err;
        renderErrorState(err);
      })
      .finally(function () {
        isLoading = false;
      });
  }

  function init() {
    versionPill = document.getElementById('version-pill');
    versionText = document.getElementById('version-text');
    descLoading = document.getElementById('desc-loading');
    descText = document.getElementById('desc-text');
    btnIos = document.getElementById('btn-ios');
    btnAndroid = document.getElementById('btn-android');
    iosWrap = document.getElementById('ios-wrap');
    androidWrap = document.getElementById('android-wrap');
    platformHint = document.getElementById('platform-hint');
    errorBox = document.getElementById('error-box');
    errorText = document.getElementById('error-text');
    retryBtn = document.getElementById('retry-btn');
    langSwitch = document.getElementById('lang-switch');
    langCodeEl = document.getElementById('lang-code');
    featuresSection = document.getElementById('features-section');
    metaDescription = document.getElementById('meta-description');

    if (!btnIos || !btnAndroid || !platformHint) return;

    currentLang = resolveLang();
    applyStaticI18n();

    if (langSwitch) {
      langSwitch.addEventListener('click', toggleLang);
    }
    retryBtn.addEventListener('click', loadVersion);
    setRecommended(detectPlatform());
    loadVersion();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
