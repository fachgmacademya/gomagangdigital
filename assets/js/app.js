/**
 * Website Program Magang - Main Application Logic
 * Integrates WhatsApp tracking, interactive UI helpers, and dynamic hydration.
 */

(function() {
  "use strict";

  document.addEventListener("DOMContentLoaded", function() {
    // -------------------------------------------------------------------------
    // 1. WhatsApp CTA Click Event Tracking (PRD Section 16)
    // -------------------------------------------------------------------------
    function trackCtaClick(eventName, location) {
      if (typeof window.dataLayer !== "undefined") {
        window.dataLayer.push({
          event: eventName,
          cta_location: location,
          timestamp: new Date().toISOString()
        });
      }
      // Optional debug logging in development
      // console.log("[Analytics] CTA Event:", eventName, "Location:", location);
    }

    // Attach tracking listeners to all WhatsApp CTA triggers
    document.querySelectorAll("[data-whatsapp-track]").forEach(function(el) {
      el.addEventListener("click", function() {
        const trackId = this.getAttribute("data-whatsapp-track") || "click_whatsapp_general";
        trackCtaClick(trackId, this.getAttribute("data-location") || "page");
      });
    });

    // -------------------------------------------------------------------------
    // 2. Dynamic Update of Year in Footer
    // -------------------------------------------------------------------------
    const yearSpan = document.getElementById("current-year");
    if (yearSpan) {
      yearSpan.textContent = new Date().getFullYear();
    }

    // -------------------------------------------------------------------------
    // 3. Optional Supabase Hydration Check
    // -------------------------------------------------------------------------
    if (window.MagangDataService) {
      // You can trigger dynamic refreshing if Supabase credentials are configured
      // The static prerendered HTML already displays all content for SEO and instant load
    }
  });

})();

