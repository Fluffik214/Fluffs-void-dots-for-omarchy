// Runs in the page: toggle picture-in-picture for the largest playing video.
function togglePip() {
  if (document.pictureInPictureElement) {
    document.exitPictureInPicture();
    return;
  }
  const videos = [...document.querySelectorAll("video")].filter((v) => v.readyState > 0);
  videos.sort((a, b) => b.clientWidth * b.clientHeight - a.clientWidth * a.clientHeight);
  const video = videos[0];
  if (!video) return;
  video.removeAttribute("disablepictureinpicture");
  video.requestPictureInPicture();
}

chrome.action.onClicked.addListener((tab) => {
  chrome.scripting.executeScript({ target: { tabId: tab.id }, func: togglePip });
});
