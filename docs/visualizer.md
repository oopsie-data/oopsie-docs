---
title: Dataset Visualizer
layout: default
nav_order: 6
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
    --viz-accent: #2563eb;
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
    outline: 2px solid rgba(37, 99, 235, 0.2);
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

  .viz-filters {
    position: sticky;
    top: 1rem;
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
  }

  .viz-filter-group {
    border: 1px solid var(--viz-border);
    background: var(--viz-surface);
    border-radius: 8px;
    padding: 0.75rem;
    min-width: 0;
  }

  .viz-filter-title {
    margin: 0 0 0.5rem;
    font-size: 0.9rem;
    font-weight: 700;
    color: var(--viz-ink);
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

  .viz-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    gap: 0.75rem;
  }

  body.viz-nav-collapsed .side-bar {
    transform: translateX(-100%);
  }

  body.viz-nav-collapsed .main {
    width: 100%;
    max-width: none;
    margin-left: 0;
  }

  body.viz-nav-collapsed .main-content {
    max-width: 1200px;
    margin-left: auto;
    margin-right: auto;
  }

  .side-bar,
  .main {
    transition: transform 180ms ease, margin-left 180ms ease, width 180ms ease, max-width 180ms ease;
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
    border: 1px solid #fecaca;
    border-radius: 8px;
    background: #fef2f2;
    color: #991b1b;
  }

  .viz-modal {
    position: fixed;
    inset: 0;
    z-index: 100;
    display: none;
    place-items: center;
    padding: 1.25rem;
  }

  .viz-modal.is-visible {
    display: grid;
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
    max-height: calc(100vh - 2.5rem);
    overflow: hidden;
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

  @media (max-width: 900px) {
    .viz-layout {
      grid-template-columns: 1fr;
    }

    .viz-filters {
      position: static;
    }

    .viz-modal-panel {
      grid-template-columns: 1fr;
      overflow: auto;
    }

    .viz-modal-media {
      padding: 0.75rem;
    }

    .viz-modal-video {
      max-height: none;
    }

    .viz-modal-details {
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
      <button class="viz-button" id="viz-nav-toggle" type="button">Show navigation</button>
      <button class="viz-button" id="viz-resample" type="button">Resample</button>
    </div>
  </div>

  <div class="viz-layout">
    <section class="viz-grid" id="viz-grid" aria-live="polite"></section>
    <aside class="viz-filters" id="viz-filters" aria-label="Dataset filters"></aside>
  </div>

  <div class="viz-modal" id="viz-modal" aria-hidden="true">
    <div class="viz-modal-backdrop" id="viz-modal-backdrop"></div>
    <section class="viz-modal-panel" role="dialog" aria-modal="true" aria-labelledby="viz-modal-title">
      <button class="viz-button viz-modal-close" id="viz-modal-close" type="button" aria-label="Close details">
        <span aria-hidden="true">&times;</span>
      </button>
      <div class="viz-modal-media">
        <video class="viz-modal-video" id="viz-modal-video" controls muted loop playsinline></video>
      </div>
      <div class="viz-modal-details" id="viz-modal-details"></div>
    </section>
  </div>
</div>

<script>
(() => {
  const metadataUrl = "{{ '/assets/visualizer/metadata.json' | relative_url }}";
  const assetBaseUrl = "{{ '/assets/visualizer/' | relative_url }}";
  const maxVisibleVideos = 40;
  const filterDefs = [
    { key: "scene", title: "Labs", idField: "scene_id", labelField: "scene_label" },
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

  const countEl = document.getElementById("viz-count");
  const filtersEl = document.getElementById("viz-filters");
  const gridEl = document.getElementById("viz-grid");
  const resampleButton = document.getElementById("viz-resample");
  const navToggleButton = document.getElementById("viz-nav-toggle");
  const searchInput = document.getElementById("viz-search");
  const modalEl = document.getElementById("viz-modal");
  const modalBackdrop = document.getElementById("viz-modal-backdrop");
  const modalCloseButton = document.getElementById("viz-modal-close");
  const modalVideo = document.getElementById("viz-modal-video");
  const modalDetails = document.getElementById("viz-modal-details");

  let videos = [];
  let shuffledIndices = [];
  let searchQuery = "";
  const selected = {};
  const checkboxRefs = {};

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      const video = entry.target;
      video.src = video.dataset.src;
      video.load();
      observer.unobserve(video);
    });
  }, { rootMargin: "240px" });

  function setNavigationCollapsed(collapsed) {
    document.body.classList.toggle("viz-nav-collapsed", collapsed);
    navToggleButton.textContent = collapsed ? "Show navigation" : "Hide navigation";
    localStorage.setItem("oopsieVisualizerNavCollapsed", collapsed ? "true" : "false");
  }

  const storedNavState = localStorage.getItem("oopsieVisualizerNavCollapsed");
  setNavigationCollapsed(storedNavState === null ? true : storedNavState === "true");

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
    };
  }

  function searchText(video) {
    if (video._searchText) return video._searchText;
    const parts = [
      textFromHtml(video.info),
      video.scene_label,
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
    return matchesSearch(video) && filterDefs.every((filter) => isSelected(video, filter));
  }

  function labelsForFilter(video, filter) {
    const labels = video[filter.labelField];
    if (filter.multi) return Array.isArray(labels) ? labels : [labels].filter(Boolean);
    return [labels].filter(Boolean);
  }

  function deriveFilterValues(filter) {
    const values = {};
    videos.forEach((video) => {
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

  function updateFilterCounts() {
    filterDefs.forEach((filter) => {
      const counts = {};

      videos.forEach((video) => {
        if (!matchesSearch(video)) return;

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
    return [
      `<div class="viz-overlay-title">${escapeHtml(videoTitle(video))}</div>`,
      `<div class="viz-overlay-meta">${escapeHtml(video.scene_label)} / ${escapeHtml(video.camera_label)} / ${escapeHtml(video.task_label)}</div>`,
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

  function showDetails(video) {
    modalVideo.pause();
    if (video.poster) modalVideo.poster = assetUrl(video.poster);
    else modalVideo.removeAttribute("poster");
    modalVideo.src = assetUrl(video.src);
    modalVideo.load();
    modalVideo.play().catch(() => {});

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
        ${detailItem("Lab", video.scene_label)}
        ${detailItem("Camera", video.camera_label)}
        ${detailItem("Outcome", video.task_label)}
      </div>
    `;

    modalEl.classList.add("is-visible");
    modalEl.setAttribute("aria-hidden", "false");
    modalCloseButton.focus();
  }

  function closeDetails() {
    modalEl.classList.remove("is-visible");
    modalEl.setAttribute("aria-hidden", "true");
    modalVideo.pause();
    modalVideo.removeAttribute("src");
    modalVideo.load();
  }

  function render() {
    observer.disconnect();
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
      media.loop = true;
      media.autoplay = true;
      media.playsInline = true;
      media.controls = false;
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
    countEl.textContent = visible.length === matches.length
      ? `Showing ${matches.length} episodes`
      : `Showing ${visible.length} episodes sampled from ${matches.length} matches`;
    resampleButton.style.display = matches.length > maxVisibleVideos ? "" : "none";

    updateFilterCounts();
  }

  resampleButton.addEventListener("click", () => {
    shuffle(shuffledIndices);
    render();
  });

  navToggleButton.addEventListener("click", () => {
    setNavigationCollapsed(!document.body.classList.contains("viz-nav-collapsed"));
  });

  modalCloseButton.addEventListener("click", closeDetails);
  modalBackdrop.addEventListener("click", closeDetails);
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && modalEl.classList.contains("is-visible")) {
      closeDetails();
    }
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
