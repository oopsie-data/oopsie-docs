---
title: Dataset Visualizer
layout: default
nav_order: 2
parent: Dataset
permalink: /visualizer/
---

# Dataset Visualizer

<style>
  .oopsie-visualizer {
    --viz-border: #e2e8f0;
    --viz-border-strong: #cbd5e1;
    --viz-surface: #ffffff;
    --viz-surface-soft: #f8fafc;
    --viz-ink: #0f172a;
    --viz-muted: #64748b;
    --viz-accent: #1b6e94;
  }

  .oopsie-visualizer * {
    box-sizing: border-box;
  }

  .viz-toolbar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: space-between;
    gap: 0.75rem;
    margin: 1rem 0;
    padding: 0.75rem 0;
    border-top: 1px solid var(--viz-border);
    border-bottom: 1px solid var(--viz-border);
  }

  .viz-toolbar-actions {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .viz-count {
    color: var(--viz-muted);
    font-size: 0.9rem;
  }

  .viz-search {
    flex: 1 1 260px;
    max-width: 420px;
    min-height: 2.25rem;
    border: 1px solid var(--viz-border-strong);
    border-radius: 6px;
    padding: 0.4rem 0.65rem;
    color: var(--viz-ink);
    background: var(--viz-surface);
    font-size: 0.9rem;
  }

  .viz-search:focus {
    outline: 2px solid rgba(27, 110, 148, 0.25);
    border-color: var(--viz-accent);
  }

  .viz-button {
    border: 1px solid var(--viz-border-strong);
    background: var(--viz-surface);
    color: var(--viz-ink);
    min-height: 2.25rem;
    padding: 0.4rem 0.75rem;
    border-radius: 6px;
    font-size: 0.9rem;
    cursor: pointer;
  }

  .viz-button:hover {
    border-color: var(--viz-accent);
    color: var(--viz-accent);
  }

  .viz-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr) minmax(220px, 260px);
    gap: 0.75rem;
    align-items: start;
  }

  /* Filters come first in the DOM so they sit above the grid on narrow
     viewports; on desktop they are placed back into the right-hand column. */
  .viz-grid {
    grid-column: 1;
    grid-row: 1;
  }

  .viz-filters {
    grid-column: 2;
    grid-row: 1;
    min-width: 0;
  }

  /* Distance from the viewport top to the first free pixel: the fixed
     announcement plus the sticky docs header (both published by script). */
  .oopsie-visualizer {
    --viz-sticky-top: calc(var(--announcement-h, 0px) + var(--viz-header-h, 0px) + 0.75rem);
  }

  .viz-filters-body {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
  }

  .viz-filters-toggle {
    display: none;
    width: 100%;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 0.75rem;
    padding: 0.6rem 0.85rem;
    border: 1px solid var(--viz-border-strong);
    border-radius: 8px;
    background: var(--viz-surface);
    color: var(--viz-ink);
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
  }

  .viz-filters-toggle-count {
    color: var(--viz-muted);
    font-size: 0.85rem;
    font-weight: 500;
  }

  .viz-filters-toggle-chevron {
    margin-left: auto;
    transition: transform 150ms ease;
  }

  .viz-filters.is-open .viz-filters-toggle-chevron {
    transform: rotate(180deg);
  }

  .viz-filter-group {
    border: 1px solid var(--viz-border);
    background: var(--viz-surface);
    border-radius: 8px;
    padding: 0.75rem;
    min-width: 0;
  }

  .oopsie-visualizer h2.viz-filter-title,
  .viz-filter-title {
    margin: 0 0 0.5rem;
    padding: 0;
    font-size: 0.9rem;
    font-weight: 700;
    color: var(--viz-ink);
    line-height: 1.25;
    border: 0;
  }

  .viz-filter-title .anchor-heading {
    display: none;
  }

  .viz-check {
    display: grid;
    grid-template-columns: 1rem minmax(0, 1fr);
    align-items: start;
    gap: 0.45rem;
    min-height: 1.55rem;
    margin: 0.25rem 0;
    color: var(--viz-ink);
    font-size: 0.8rem;
    line-height: 1.25;
  }

  .viz-check input {
    margin-top: 0.14rem;
  }

  .viz-check span {
    overflow-wrap: anywhere;
  }

  .viz-check[data-disabled="true"] {
    color: var(--viz-muted);
  }

  .viz-bulk-toggle {
    display: flex;
    align-items: flex-start;
    gap: 0.55rem;
    margin: 0 0 1rem;
    padding: 0.75rem 0.85rem;
    border: 1px solid rgba(15, 23, 42, 0.12);
    border-radius: 10px;
    background: #f8fafc;
    font-size: 0.92rem;
    line-height: 1.35;
    color: #334155;
    cursor: pointer;
  }

  .viz-bulk-toggle input {
    margin-top: 0.15rem;
  }

  .viz-bulk-toggle span {
    flex: 1;
  }

  .viz-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    gap: 0.75rem;
  }

  body.docs-nav-collapsed .main-content {
    max-width: 1200px;
    margin-left: auto;
    margin-right: auto;
  }

  .viz-video {
    position: relative;
    overflow: hidden;
    border: 1px solid var(--viz-border);
    border-radius: 8px;
    background: var(--viz-surface-soft);
    aspect-ratio: 16 / 9;
    cursor: pointer;
  }

  .viz-video video {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .viz-overlay {
    position: absolute;
    inset: 0;
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    gap: 0.4rem;
    padding: 0.7rem;
    color: #fff;
    font-size: 0.78rem;
    line-height: 1.25;
    background: linear-gradient(180deg, transparent 18%, rgba(15, 23, 42, 0.92) 68%);
    opacity: 0;
    overflow: hidden;
    transition: opacity 160ms ease;
  }

  .viz-video:hover .viz-overlay,
  .viz-video:focus .viz-overlay,
  .viz-video:focus-within .viz-overlay,
  .viz-video.is-open .viz-overlay {
    opacity: 1;
  }

  .viz-overlay-title {
    font-weight: 700;
    display: -webkit-box;
    overflow: hidden;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }

  .viz-overlay-meta {
    color: rgba(255, 255, 255, 0.88);
    display: -webkit-box;
    overflow: hidden;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 1;
  }

  .viz-overlay-chip {
    width: fit-content;
    max-width: 100%;
    border: 1px solid rgba(255, 255, 255, 0.24);
    border-radius: 999px;
    padding: 0.18rem 0.45rem;
    color: rgba(255, 255, 255, 0.92);
    background: rgba(15, 23, 42, 0.48);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .viz-error {
    padding: 0.85rem 1rem;
    border: 1px solid #eec9c5;
    border-radius: 8px;
    background: #fdf3f2;
    color: #aa1910;
  }

  .viz-modal {
    position: fixed;
    top: var(--announcement-h, 0px);
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 950;
    display: none;
    place-items: center;
    padding: 1.25rem;
    overscroll-behavior: contain;
  }

  .viz-modal.is-visible {
    display: grid;
  }

  body.viz-modal-open {
    position: fixed;
    right: 0;
    left: 0;
    width: 100%;
    overflow: hidden;
  }

  .viz-modal-backdrop {
    position: absolute;
    inset: 0;
    background: rgba(15, 23, 42, 0.72);
  }

  .viz-modal-panel {
    position: relative;
    z-index: 1;
    display: grid;
    grid-template-columns: minmax(0, 1.35fr) minmax(320px, 0.65fr);
    width: min(1120px, 100%);
    max-height: calc(100% - 2.5rem);
    overflow: hidden;
    overscroll-behavior: contain;
    border: 1px solid var(--viz-border);
    border-radius: 10px;
    background: var(--viz-surface);
    box-shadow: 0 20px 60px rgba(15, 23, 42, 0.28);
  }

  .viz-modal-media {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 0;
    padding: 1rem;
    background: #020617;
  }

  .viz-modal-video {
    display: block;
    width: 100%;
    max-height: calc(100vh - 4.5rem);
    aspect-ratio: 16 / 9;
    border-radius: 8px;
    background: #020617;
  }

  .viz-modal-details {
    overflow: auto;
    border-left: 1px solid var(--viz-border);
    background: var(--viz-surface-soft);
    padding: 1.25rem;
    color: var(--viz-ink);
    font-size: 0.9rem;
    line-height: 1.45;
  }

  .viz-modal-title {
    margin: 0 2.75rem 0.8rem 0;
    font-size: 1.08rem;
    line-height: 1.35;
    color: var(--viz-ink);
  }

  .viz-detail-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
    margin-bottom: 1rem;
  }

  .viz-chip {
    min-width: 0;
    border: 1px solid var(--viz-border-strong);
    border-radius: 999px;
    padding: 0.22rem 0.5rem;
    color: var(--viz-ink);
    background: var(--viz-surface);
    font-size: 0.75rem;
    line-height: 1.2;
  }

  .viz-detail-section {
    margin-top: 0.85rem;
    border: 1px solid var(--viz-border);
    border-radius: 8px;
    background: var(--viz-surface);
    padding: 0.8rem;
  }

  .viz-detail-section:first-child {
    margin-top: 0;
  }

  .viz-detail-description {
    white-space: pre-wrap;
  }

  .viz-detail-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 0.65rem;
    margin-top: 0.85rem;
  }

  .viz-detail-item {
    min-width: 0;
    border: 1px solid var(--viz-border);
    border-radius: 8px;
    background: var(--viz-surface);
    padding: 0.7rem;
  }

  .viz-detail-label {
    display: block;
    margin-bottom: 0.25rem;
    color: var(--viz-muted);
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
  }

  .viz-detail-value {
    overflow-wrap: anywhere;
  }

  .viz-modal-close {
    position: absolute;
    top: 0.85rem;
    right: 0.85rem;
    z-index: 2;
    display: grid;
    place-items: center;
    width: 2.1rem;
    min-height: 2.1rem;
    padding: 0;
    border-radius: 999px;
    font-size: 1.25rem;
    line-height: 1;
  }

  /* Pin the filter column and let it scroll inside itself, so the page always
     scrolls as one and the column never slides out of reach. */
  @media (min-width: 901px) {
    .viz-filters {
      position: sticky;
      top: var(--viz-sticky-top);
      max-height: calc(100vh - var(--viz-sticky-top) - 0.75rem);
      overflow-y: auto;
      overscroll-behavior: contain;
    }
  }

  @media (max-width: 900px) {
    .viz-layout {
      grid-template-columns: 1fr;
    }

    .viz-grid,
    .viz-filters {
      grid-column: 1;
      grid-row: auto;
    }

    .viz-filters-toggle {
      display: flex;
    }

    .viz-filters-body {
      display: none;
      max-height: 65vh;
      overflow-y: auto;
      overscroll-behavior: contain;
      -webkit-overflow-scrolling: touch;
    }

    .viz-filters.is-open .viz-filters-body {
      display: flex;
    }

    .viz-modal-panel {
      grid-template-columns: 1fr;
      height: 100%;
      max-height: 100%;
      overflow: auto;
      overscroll-behavior: contain;
      -webkit-overflow-scrolling: touch;
    }

    .viz-modal-media {
      padding: 0.75rem;
    }

    .viz-modal-video {
      max-height: none;
    }

    .viz-modal-details {
      overflow: visible;
      border-left: 0;
      border-top: 1px solid var(--viz-border);
    }
  }

  @media (max-width: 560px) {
    .viz-detail-grid {
      grid-template-columns: 1fr;
    }
  }
</style>

<div class="oopsie-visualizer" id="oopsie-visualizer">
  <div class="viz-toolbar">
    <div class="viz-count" id="viz-count">Loading episodes</div>
    <input class="viz-search" id="viz-search" type="search" placeholder="Search instructions or annotations">
    <div class="viz-toolbar-actions">
      <button class="viz-button" id="viz-resample" type="button">Resample</button>
    </div>
  </div>

{% include docs-nav-collapse.html %}

  <div class="viz-layout">
    <aside class="viz-filters" id="viz-filters-panel" aria-label="Dataset filters">
      <button class="viz-filters-toggle" id="viz-filters-toggle" type="button" aria-expanded="false" aria-controls="viz-filters">
        <span>Filters</span>
        <span class="viz-filters-toggle-count" id="viz-filters-toggle-count"></span>
        <span class="viz-filters-toggle-chevron" aria-hidden="true">&#9662;</span>
      </button>
      <div class="viz-filters-body" id="viz-filters"></div>
    </aside>
    <section class="viz-grid" id="viz-grid" aria-live="polite"></section>
  </div>

  <div class="viz-modal" id="viz-modal" aria-hidden="true">
    <div class="viz-modal-backdrop" id="viz-modal-backdrop"></div>
    <section class="viz-modal-panel" role="dialog" aria-modal="true" aria-labelledby="viz-modal-title">
      <button class="viz-button viz-modal-close" id="viz-modal-close" type="button" aria-label="Close details">
        <span aria-hidden="true">&times;</span>
      </button>
      <div class="viz-modal-media">
        <video class="viz-modal-video" id="viz-modal-video" controls muted loop playsinline webkit-playsinline preload="metadata"></video>
      </div>
      <div class="viz-modal-details" id="viz-modal-details"></div>
    </section>
  </div>
</div>

<script>
(() => {
  const configuredAssetBase = "{{ site.visualizer_asset_base }}";
  const localAssetBase = "{{ '/assets/visualizer/' | relative_url }}";
  const localMetadataUrl = "{{ '/assets/visualizer/metadata.json' | relative_url }}";
  const isLocalHost =
    location.hostname === "localhost" ||
    location.hostname === "127.0.0.1" ||
    location.hostname === "[::1]";
  const useRemoteAssets = Boolean(configuredAssetBase);
  const assetBaseUrl = useRemoteAssets ? configuredAssetBase : localAssetBase;
  const metadataUrl = useRemoteAssets
    ? `${configuredAssetBase.replace(/\/?$/, "/")}metadata.json`
    : localMetadataUrl;
  const isPublicVisualizer = useRemoteAssets;
  const maxVisibleVideos = 40;
  const maxPlayingPreviews = 8;
  const allFilterDefs = [
    { key: "scene", title: "Datasets", idField: "scene_id", labelField: "scene_label" },
    { key: "camera", title: "Cameras", idField: "camera_id", labelField: "camera_label" },
    { key: "task", title: "Outcomes", idField: "task_id", labelField: "task_label" },
    { key: "annotation", title: "Annotations", idField: "annotation_id", labelField: "annotation_label" },
    {
      key: "failure_category",
      title: "Failure Categories",
      idField: "failure_category_ids",
      labelField: "failure_category_labels",
      multi: true,
    },
    { key: "severity", title: "Severity", idField: "severity_id", labelField: "severity_label" },
  ];
  const filterDefs = isPublicVisualizer
    ? allFilterDefs.filter((filter) => filter.key !== "scene" && filter.key !== "camera")
    : allFilterDefs;

  const countEl = document.getElementById("viz-count");
  const filtersEl = document.getElementById("viz-filters");
  const filtersPanel = document.getElementById("viz-filters-panel");
  const filtersToggle = document.getElementById("viz-filters-toggle");
  const filtersToggleCount = document.getElementById("viz-filters-toggle-count");
  const gridEl = document.getElementById("viz-grid");
  const resampleButton = document.getElementById("viz-resample");
  const searchInput = document.getElementById("viz-search");
  const modalEl = document.getElementById("viz-modal");
  const modalBackdrop = document.getElementById("viz-modal-backdrop");
  const modalCloseButton = document.getElementById("viz-modal-close");
  const modalVideo = document.getElementById("viz-modal-video");
  const modalDetails = document.getElementById("viz-modal-details");

  let videos = [];
  let shuffledIndices = [];
  let searchQuery = "";
  let includeBulkImport = false;
  let excludedRepos = new Set();
  let isModalOpen = false;
  let modalRequestId = 0;
  let pageScrollY = 0;
  const selected = {};
  const checkboxRefs = {};
  const previewCandidates = new Set();
  const videoObjectUrls = new Map();
  const pendingVideoObjectUrls = new Map();

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      const media = entry.target;
      if (entry.isIntersecting) {
        previewCandidates.add(media);
      } else {
        previewCandidates.delete(media);
        unloadPreview(media);
      }
    });
    syncPreviewPlayback();
  }, { rootMargin: "120px", threshold: 0.1 });

  /* Safari can reject byte-range playback across Hugging Face's signed Xet redirect.
     These previews are small, so fetch each one once and play it from a local Blob URL. */
  async function playableVideoUrl(sourceUrl) {
    if (videoObjectUrls.has(sourceUrl)) {
      return videoObjectUrls.get(sourceUrl);
    }

    if (!pendingVideoObjectUrls.has(sourceUrl)) {
      const request = fetch(sourceUrl, {
        mode: "cors",
        credentials: "omit",
        cache: "force-cache",
      })
        .then((response) => {
          if (!response.ok) throw new Error(`Video request failed with HTTP ${response.status}`);
          return Promise.all([response.arrayBuffer(), response.headers.get("content-type")]);
        })
        .then(([bytes, contentType]) => {
          const mimeType = contentType && contentType.startsWith("video/")
            ? contentType.split(";", 1)[0]
            : "video/mp4";
          const objectUrl = URL.createObjectURL(new Blob([bytes], { type: mimeType }));
          videoObjectUrls.set(sourceUrl, objectUrl);
          return objectUrl;
        })
        .finally(() => {
          pendingVideoObjectUrls.delete(sourceUrl);
        });
      pendingVideoObjectUrls.set(sourceUrl, request);
    }

    return pendingVideoObjectUrls.get(sourceUrl);
  }

  async function playPreview(media) {
    if (isModalOpen) return;

    if (!media.hasAttribute("src")) {
      if (media.dataset.loading === "true") return;
      media.dataset.loading = "true";

      try {
        const objectUrl = await playableVideoUrl(media.dataset.src);
        if (isModalOpen || !media.isConnected || !previewCandidates.has(media)) return;
        media.src = objectUrl;
        media.load();
      } catch (error) {
        console.error("Preview video could not be loaded:", error);
        return;
      } finally {
        delete media.dataset.loading;
      }
    }

    const playback = media.play();
    if (playback) {
      playback.catch((error) => {
        if (error.name !== "AbortError") {
          console.debug("Preview playback was blocked:", error);
        }
      });
    }
  }

  function unloadPreview(media) {
    media.pause();
    if (media.hasAttribute("src")) {
      media.removeAttribute("src");
      media.load();
    }
  }

  function syncPreviewPlayback() {
    const viewportCenter = window.innerHeight / 2;
    const candidates = Array.from(previewCandidates)
      .filter((media) => media.isConnected)
      .sort((left, right) => {
        const leftBounds = left.getBoundingClientRect();
        const rightBounds = right.getBoundingClientRect();
        const leftCenter = leftBounds.top + leftBounds.height / 2;
        const rightCenter = rightBounds.top + rightBounds.height / 2;
        return Math.abs(leftCenter - viewportCenter) - Math.abs(rightCenter - viewportCenter);
      });
    const playing = new Set(isModalOpen ? [] : candidates.slice(0, maxPlayingPreviews));

    candidates.forEach((media) => {
      if (playing.has(media)) playPreview(media);
      else unloadPreview(media);
    });
  }

  function shuffle(array) {
    for (let index = array.length - 1; index > 0; index -= 1) {
      const swapIndex = Math.floor(Math.random() * (index + 1));
      [array[index], array[swapIndex]] = [array[swapIndex], array[index]];
    }
  }

  function assetUrl(path) {
    if (!path) return "";
    return assetBaseUrl + path;
  }

  function escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function normalizeText(value) {
    return String(value || "").replace(/\s+/g, " ").trim();
  }

  function safeName(value) {
    return normalizeText(value).replace(/[^a-z0-9]+/gi, "_").replace(/^_+|_+$/g, "").toLowerCase() || "unknown";
  }

  function normalizedElementText(element) {
    element.querySelectorAll("br").forEach((breakEl) => {
      breakEl.replaceWith(" ");
    });
    return normalizeText(element.textContent);
  }

  function textFromHtml(html) {
    const element = document.createElement("div");
    element.innerHTML = html || "";
    return normalizedElementText(element);
  }

  function videoTitle(video) {
    const element = document.createElement("div");
    element.innerHTML = video.info || "";
    let title = "";

    for (const node of element.childNodes) {
      if (node.nodeName === "BR" || (node.nodeType === 1 && node.tagName === "SMALL")) break;
      title += ` ${node.textContent || ""}`;
    }

    return normalizeText(title) || textFromHtml(video.info) || video.episode_id || "Episode";
  }

  function normalizedSeverity(value) {
    const text = normalizeText(value);
    const lower = text.toLowerCase();
    if (lower.startsWith("low")) return "Low";
    if (lower.startsWith("medium")) return "Medium";
    if (lower.startsWith("high")) return "High";
    return text || "No severity";
  }

  function normalizeVideo(video) {
    const severityLabel = normalizedSeverity(video.severity_label);
    const hasAnnotation = Boolean(
      video.failure_description ||
      (video.failure_category_labels && video.failure_category_labels.length) ||
      severityLabel !== "No severity"
    );

    return {
      ...video,
      camera_id: video.camera_id || video.object_id,
      camera_label: video.camera_label || video.object_label || "Unknown camera",
      annotation_id: video.annotation_id || (hasAnnotation ? "annotation-has_failure_annotation" : "annotation-no_failure_annotation"),
      annotation_label: video.annotation_label || (hasAnnotation ? "Has failure annotation" : "No failure annotation"),
      failure_category_ids: video.failure_category_ids || ["failure_category-no_failure_category"],
      failure_category_labels: video.failure_category_labels || ["No failure category"],
      severity_id: `severity-${safeName(severityLabel)}`,
      severity_label: severityLabel,
      failure_description: video.failure_description || "",
      additional_notes: video.additional_notes || "",
      dataset_repo: video.dataset_repo || "",
      bulk_import: Boolean(video.bulk_import),
    };
  }

  function isBulkImport(video) {
    if (video.bulk_import) return true;
    return Boolean(video.dataset_repo) && excludedRepos.has(video.dataset_repo);
  }

  function isCorpusVisible(video) {
    return includeBulkImport || !isBulkImport(video);
  }

  function searchText(video) {
    if (video._searchText) return video._searchText;
    const parts = [
      textFromHtml(video.info),
      isPublicVisualizer ? null : video.scene_label,
      isPublicVisualizer ? null : video.dataset_repo,
      video.camera_label,
      video.task_label,
      video.annotation_label,
      ...(video.failure_category_labels || []),
      video.severity_label,
      video.failure_description,
      video.additional_notes,
      video.episode_id,
    ];
    video._searchText = parts.filter(Boolean).join(" ").toLowerCase();
    return video._searchText;
  }

  function matchesSearch(video) {
    if (!searchQuery) return true;
    return searchText(video).includes(searchQuery);
  }

  function filterValues(video, filter) {
    const value = video[filter.idField];
    if (filter.multi) return Array.isArray(value) ? value : [value].filter(Boolean);
    return [value].filter(Boolean);
  }

  function isSelected(video, filter) {
    if (selected[filter.key].size === 0) return true;
    return filterValues(video, filter).some((value) => selected[filter.key].has(value));
  }

  function matchesAll(video) {
    return (
      isCorpusVisible(video) &&
      matchesSearch(video) &&
      filterDefs.every((filter) => isSelected(video, filter))
    );
  }

  function labelsForFilter(video, filter) {
    const labels = video[filter.labelField];
    if (filter.multi) return Array.isArray(labels) ? labels : [labels].filter(Boolean);
    return [labels].filter(Boolean);
  }

  function deriveFilterValues(filter) {
    const values = {};
    videos.forEach((video) => {
      if (!isCorpusVisible(video)) return;
      const ids = filterValues(video, filter);
      const labels = labelsForFilter(video, filter);
      ids.forEach((id, index) => {
        values[id] = labels[index] || id;
      });
    });
    return values;
  }

  function buildFilters(metadata) {
    filtersEl.textContent = "";

    if (!isPublicVisualizer) {
      const bulkToggle = document.createElement("label");
      bulkToggle.className = "viz-bulk-toggle";
      const bulkInput = document.createElement("input");
      bulkInput.type = "checkbox";
      bulkInput.checked = includeBulkImport;
      bulkInput.addEventListener("change", () => {
        includeBulkImport = bulkInput.checked;
        buildFilters(metadata);
        render();
      });
      const bulkText = document.createElement("span");
      bulkText.textContent = "Show bulk-import datasets (SOAR, etc.)";
      bulkToggle.append(bulkInput, bulkText);
      filtersEl.append(bulkToggle);
    }

    filterDefs.forEach((filter) => {
      selected[filter.key] = new Set();
      checkboxRefs[filter.key] = {};

      const group = document.createElement("section");
      group.className = "viz-filter-group";

      const title = document.createElement("h2");
      title.className = "viz-filter-title";
      title.textContent = filter.title;
      group.append(title);

      const values = deriveFilterValues(filter);
      Object.entries(values)
        .sort((left, right) => left[1].localeCompare(right[1]))
        .forEach(([id, label]) => {
          const row = document.createElement("label");
          row.className = "viz-check";

          const input = document.createElement("input");
          input.type = "checkbox";
          input.value = id;
          input.addEventListener("change", () => {
            if (input.checked) selected[filter.key].add(id);
            else selected[filter.key].delete(id);
            render();
          });

          const text = document.createElement("span");
          text.textContent = label;

          row.append(input, text);
          group.append(row);
          checkboxRefs[filter.key][id] = { input, text, row, label };
        });

      filtersEl.append(group);
    });
  }

  function updateFilterSummary() {
    const active = filterDefs.reduce(
      (total, filter) => total + (selected[filter.key] ? selected[filter.key].size : 0),
      0,
    );
    filtersToggleCount.textContent = active === 0 ? "" : `${active} selected`;
  }

  function updateFilterCounts() {
    filterDefs.forEach((filter) => {
      const counts = {};

      videos.forEach((video) => {
        if (!isCorpusVisible(video) || !matchesSearch(video)) return;

        const matchesOtherFilters = filterDefs.every((otherFilter) => {
          return otherFilter.key === filter.key || isSelected(video, otherFilter);
        });
        if (!matchesOtherFilters) return;

        filterValues(video, filter).forEach((value) => {
          counts[value] = (counts[value] || 0) + 1;
        });
      });

      Object.entries(checkboxRefs[filter.key]).forEach(([id, ref]) => {
        const count = counts[id] || 0;
        ref.text.textContent = `${ref.label} (${count})`;
        ref.input.disabled = count === 0;
        ref.row.dataset.disabled = count === 0 ? "true" : "false";
      });
    });
  }

  function previewHtml(video) {
    const metaBits = isPublicVisualizer
      ? [video.camera_label, video.task_label]
      : [video.scene_label, video.camera_label, video.task_label];
    return [
      `<div class="viz-overlay-title">${escapeHtml(videoTitle(video))}</div>`,
      `<div class="viz-overlay-meta">${escapeHtml(metaBits.filter(Boolean).join(" / "))}</div>`,
      `<div class="viz-overlay-chip">${escapeHtml(video.annotation_label)}</div>`,
      `<div class="viz-overlay-meta">${escapeHtml(video.failure_category_labels.join(", "))} / ${escapeHtml(video.severity_label)}</div>`,
    ].join("");
  }

  function detailSection(label, value) {
    if (!value) return "";
    return `
      <section class="viz-detail-section">
        <span class="viz-detail-label">${escapeHtml(label)}</span>
        <div class="viz-detail-value viz-detail-description">${escapeHtml(value)}</div>
      </section>
    `;
  }

  function detailItem(label, value) {
    if (!value) return "";
    return `
      <div class="viz-detail-item">
        <span class="viz-detail-label">${escapeHtml(label)}</span>
        <div class="viz-detail-value">${escapeHtml(value)}</div>
      </div>
    `;
  }

  function detailChip(value) {
    if (!value) return "";
    return `<span class="viz-chip">${escapeHtml(value)}</span>`;
  }

  async function showDetails(video) {
    const requestId = ++modalRequestId;
    isModalOpen = true;
    pageScrollY = window.scrollY;
    document.body.style.top = `-${pageScrollY}px`;
    document.body.classList.add("viz-modal-open");
    gridEl.querySelectorAll("video").forEach(unloadPreview);

    modalVideo.pause();
    modalVideo.removeAttribute("src");
    modalVideo.load();
    if (video.poster) modalVideo.poster = assetUrl(video.poster);
    else modalVideo.removeAttribute("poster");

    modalDetails.innerHTML = `
      <h2 class="viz-modal-title" id="viz-modal-title">${escapeHtml(videoTitle(video))}</h2>
      <div class="viz-detail-chips">
        ${detailChip(video.annotation_label)}
        ${detailChip(video.failure_category_labels.join(", "))}
        ${detailChip(video.severity_label)}
      </div>
      ${detailSection("Failure description", video.failure_description)}
      ${detailSection("Additional notes", video.additional_notes)}
      <div class="viz-detail-grid">
        ${detailItem("Episode", video.episode_id)}
        ${isPublicVisualizer ? "" : detailItem("Dataset", video.scene_label)}
        ${detailItem("Camera", video.camera_label)}
        ${detailItem("Outcome", video.task_label)}
      </div>
    `;

    modalEl.classList.add("is-visible");
    modalEl.setAttribute("aria-hidden", "false");
    modalCloseButton.focus();

    try {
      const objectUrl = await playableVideoUrl(assetUrl(video.src));
      if (!isModalOpen || requestId !== modalRequestId) return;

      modalVideo.src = objectUrl;
      modalVideo.load();
      const playback = modalVideo.play();
      if (playback) await playback;
    } catch (error) {
      if (!isModalOpen || requestId !== modalRequestId) return;
      if (error.name === "NotAllowedError") {
        console.debug("Modal autoplay was blocked; native controls remain available:", error);
        return;
      }

      console.error("Modal video playback failed:", error, modalVideo.error);
      const playbackError = document.createElement("div");
      playbackError.className = "viz-error";
      playbackError.textContent =
        "This video could not be loaded. Reload the page and try again.";
      modalDetails.prepend(playbackError);
    }
  }

  function closeDetails() {
    modalRequestId += 1;
    isModalOpen = false;
    modalEl.classList.remove("is-visible");
    modalEl.setAttribute("aria-hidden", "true");
    modalVideo.pause();
    modalVideo.removeAttribute("src");
    modalVideo.load();
    document.body.classList.remove("viz-modal-open");
    document.body.style.removeProperty("top");
    window.scrollTo(0, pageScrollY);
    syncPreviewPlayback();
  }

  function render() {
    observer.disconnect();
    previewCandidates.forEach(unloadPreview);
    previewCandidates.clear();
    gridEl.textContent = "";

    const matches = [];
    shuffledIndices.forEach((index) => {
      const video = videos[index];
      if (matchesAll(video)) matches.push(video);
    });

    const visible = matches.slice(0, maxVisibleVideos);
    const fragment = document.createDocumentFragment();

    visible.forEach((video) => {
      const item = document.createElement("article");
      item.className = "viz-video";
      item.tabIndex = 0;
      item.addEventListener("click", () => {
        showDetails(video);
      });
      item.addEventListener("keydown", (event) => {
        if (event.key === "Enter" || event.key === " ") {
          event.preventDefault();
          showDetails(video);
        }
      });

      const media = document.createElement("video");
      media.muted = true;
      media.defaultMuted = true;
      media.loop = true;
      media.playsInline = true;
      media.preload = "metadata";
      media.controls = false;
      media.setAttribute("muted", "");
      media.setAttribute("playsinline", "");
      media.setAttribute("webkit-playsinline", "");
      if (video.poster) media.poster = assetUrl(video.poster);
      media.dataset.src = assetUrl(video.src);

      const overlay = document.createElement("div");
      overlay.className = "viz-overlay";
      overlay.innerHTML = previewHtml(video);

      item.append(media, overlay);
      fragment.append(item);
      observer.observe(media);
    });

    gridEl.append(fragment);
    countEl.textContent = `Showing ${visible.length} randomly sampled episodes`;
    resampleButton.style.display = matches.length > maxVisibleVideos ? "" : "none";

    updateFilterCounts();
    updateFilterSummary();
  }

  /* The docs header is sticky under the announcement; publish its height so the
     filter column can stick just below it. */
  function syncStickyOffset() {
    const header = document.getElementById("main-header");
    const height = header && getComputedStyle(header).position === "sticky" ? header.offsetHeight : 0;
    document.documentElement.style.setProperty("--viz-header-h", height + "px");
  }

  syncStickyOffset();
  window.addEventListener("load", syncStickyOffset);
  window.addEventListener("resize", syncStickyOffset);

  filtersToggle.addEventListener("click", () => {
    const open = filtersPanel.classList.toggle("is-open");
    filtersToggle.setAttribute("aria-expanded", open ? "true" : "false");
  });

  resampleButton.addEventListener("click", () => {
    shuffle(shuffledIndices);
    render();
  });

  modalCloseButton.addEventListener("click", closeDetails);
  modalBackdrop.addEventListener("click", closeDetails);
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && modalEl.classList.contains("is-visible")) {
      closeDetails();
    }
  });

  window.addEventListener("pagehide", () => {
    videoObjectUrls.forEach((objectUrl) => URL.revokeObjectURL(objectUrl));
    videoObjectUrls.clear();
  });

  searchInput.addEventListener("input", () => {
    searchQuery = searchInput.value.trim().toLowerCase();
    render();
  });

  fetch(metadataUrl)
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();
    })
    .then((metadata) => {
      excludedRepos = new Set(metadata.excluded_from_public_datasets || []);
      videos = (metadata.videos || []).map(normalizeVideo);
      shuffledIndices = Array.from({ length: videos.length }, (_, index) => index);
      shuffle(shuffledIndices);
      buildFilters(metadata);
      render();
    })
    .catch((error) => {
      document.getElementById("oopsie-visualizer").innerHTML =
        `<div class="viz-error">Could not load visualizer metadata: ${error.message}</div>`;
    });
})();
</script>
