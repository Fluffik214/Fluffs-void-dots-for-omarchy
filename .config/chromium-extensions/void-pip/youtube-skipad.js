// Runs in YouTube's own page context: while an ad plays, register the Media
// Session "skipad" action so Chromium shows a Skip Ad button on the PiP card.
(() => {
  const player = () => document.querySelector("#movie_player");
  const adShowing = () => player()?.classList.contains("ad-showing");

  function skipAd() {
    const button = document.querySelector(
      ".ytp-skip-ad-button, .ytp-ad-skip-button, .ytp-ad-skip-button-modern"
    );
    if (button) {
      button.click();
      return;
    }
    // Unskippable ad: jump to its end.
    const video = player()?.querySelector("video");
    if (video && Number.isFinite(video.duration)) video.currentTime = video.duration;
  }

  let registered = false;
  setInterval(() => {
    const showing = adShowing();
    if (showing === registered) return;
    try {
      navigator.mediaSession.setActionHandler("skipad", showing ? skipAd : null);
      registered = showing;
    } catch (_) {}
  }, 500);
})();
