/**
 * Article Interactive Script: Dynamic TOC, Toggle & Social Share
 * Program Magang Pengembangan Website & Digital Marketing
 */
document.addEventListener("DOMContentLoaded", function () {
  // 1. Generate Dynamic Table of Contents (TOC) from H2 & H3
  const articleContent = document.querySelector(".article-content");
  const tocList = document.getElementById("toc-list");
  const tocContainer = document.getElementById("article-toc");

  if (articleContent && tocList) {
    const headings = articleContent.querySelectorAll("h2, h3");

    if (headings.length > 0) {
      headings.forEach((heading, index) => {
        // Generate slug ID if not present
        if (!heading.id) {
          const slug = heading.textContent
            .toLowerCase()
            .trim()
            .replace(/[^\w\s-]/g, "")
            .replace(/\s+/g, "-");
          heading.id = slug || `section-${index + 1}`;
        }

        const li = document.createElement("li");
        const a = document.createElement("a");
        a.href = `#${heading.id}`;
        a.textContent = heading.textContent;

        if (heading.tagName.toLowerCase() === "h2") {
          li.className = "toc-item-h2";
          a.innerHTML = `<i class="bi bi-hash me-1 text-danger"></i>${heading.textContent}`;
        } else {
          li.className = "toc-item-h3 ps-3";
          a.innerHTML = `<i class="bi bi-dot text-secondary"></i>${heading.textContent}`;
        }

        // Smooth scroll on click
        a.addEventListener("click", function (e) {
          e.preventDefault();
          const targetEl = document.getElementById(heading.id);
          if (targetEl) {
            const headerOffset = 90;
            const elementPosition = targetEl.getBoundingClientRect().top;
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

            window.scrollTo({
              top: offsetPosition,
              behavior: "smooth"
            });
            // Update URL hash
            history.pushState(null, null, `#${heading.id}`);
          }
        });

        li.appendChild(a);
        tocList.appendChild(li);
      });
    } else if (tocContainer) {
      tocContainer.style.display = "none";
    }
  }

  // 2. TOC Toggle Button (Buka / Tutup Otomatis)
  const tocToggleBtn = document.getElementById("toc-toggle-btn");
  const tocCollapseBody = document.getElementById("toc-collapse-body");
  const tocToggleIcon = document.getElementById("toc-toggle-icon");
  const tocToggleText = document.getElementById("toc-toggle-text");

  if (tocToggleBtn && tocCollapseBody) {
    // If mobile, start collapsed by default for compact reading
    if (window.innerWidth < 768) {
      tocCollapseBody.classList.remove("show");
      if (tocToggleIcon) tocToggleIcon.className = "bi bi-chevron-down ms-1";
      if (tocToggleText) tocToggleText.textContent = "Buka";
    }

    tocToggleBtn.addEventListener("click", function () {
      const isExpanded = tocCollapseBody.classList.toggle("show");
      if (isExpanded) {
        if (tocToggleIcon) tocToggleIcon.className = "bi bi-chevron-up ms-1";
        if (tocToggleText) tocToggleText.textContent = "Tutup";
      } else {
        if (tocToggleIcon) tocToggleIcon.className = "bi bi-chevron-down ms-1";
        if (tocToggleText) tocToggleText.textContent = "Buka";
      }
    });
  }

  // 3. Dynamic Social Sharing URLs & Copy Link
  const currentUrl = encodeURIComponent(window.location.href);
  const pageTitle = encodeURIComponent(document.title || "Program Magang Digital Marketing & Web Development");

  const shareWa = document.querySelectorAll(".share-btn-wa");
  shareWa.forEach(btn => {
    btn.href = `https://api.whatsapp.com/send?text=${pageTitle}%20${currentUrl}`;
  });

  const shareFb = document.querySelectorAll(".share-btn-fb");
  shareFb.forEach(btn => {
    btn.href = `https://www.facebook.com/sharer/sharer.php?u=${currentUrl}`;
  });

  const shareTw = document.querySelectorAll(".share-btn-tw");
  shareTw.forEach(btn => {
    btn.href = `https://twitter.com/intent/tweet?url=${currentUrl}&text=${pageTitle}`;
  });

  const shareIn = document.querySelectorAll(".share-btn-in");
  shareIn.forEach(btn => {
    btn.href = `https://www.linkedin.com/sharing/share-offsite/?url=${currentUrl}`;
  });

  const shareCopy = document.querySelectorAll(".share-btn-copy");
  shareCopy.forEach(btn => {
    btn.addEventListener("click", function (e) {
      e.preventDefault();
      const rawUrl = window.location.href;
      if (navigator.clipboard) {
        navigator.clipboard.writeText(rawUrl).then(() => {
          showCopyFeedback(btn);
        });
      } else {
        // Fallback for older browsers
        const tempInput = document.createElement("input");
        tempInput.value = rawUrl;
        document.body.appendChild(tempInput);
        tempInput.select();
        document.execCommand("copy");
        document.body.removeChild(tempInput);
        showCopyFeedback(btn);
      }
    });
  });

  function showCopyFeedback(btn) {
    const originalText = btn.innerHTML;
    btn.innerHTML = `<i class="bi bi-check2-circle me-1"></i> Tersalin!`;
    btn.classList.add("btn-success");
    btn.classList.remove("btn-outline-secondary");
    setTimeout(() => {
      btn.innerHTML = originalText;
      btn.classList.remove("btn-success");
      btn.classList.add("btn-outline-secondary");
    }, 2000);
  }
});

