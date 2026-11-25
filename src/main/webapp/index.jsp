<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ include file="/WEB-INF/jspf/lang.jspf" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <c:set var="pageTitleKey" scope="request" value="site.title" />
        <fmt:message key="home.meta.description" var="homeMetaDescription" />
        <fmt:message key="site.title" var="homeMetaTitle" />
        <fmt:message key="contact.email" var="homeContactEmail" />
        <fmt:message key="contact.phone" var="homeContactPhone" />
        <c:set var="homeContactPhoneHref" value="${fn:replace(homeContactPhone, ' ', '')}" />
        <!DOCTYPE html>
        <html lang="${sessionScope.bloodlinkLocale}">

        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <meta name="theme-color" content="#76131d">
          <meta name="description" content="<c:out value='${homeMetaDescription}'/>">
          <meta property="og:title" content="<c:out value='${homeMetaTitle}'/>">
          <meta property="og:description" content="<c:out value='${homeMetaDescription}'/>">
          <meta property="og:type" content="website">
          <meta property="og:url" content="<c:out value='${pageContext.request.requestURL}'/>">
          <meta property="og:locale" content="${sessionScope.bloodlinkLocale eq 'bn' ? 'bn_BD' : 'en_US'}">
          <meta property="og:site_name" content="BloodLink">
          <link rel="icon" type="image/svg+xml"
            href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 48 48'%3E%3Cpath fill='%23b4232f' d='M24 2C18 13 7 25 7 34a17 17 0 0 0 34 0C41 25 30 13 24 2Z'/%3E%3Cpath d='M17 33c0 4 3 7 7 8' fill='none' stroke='%23fff' stroke-linecap='round' stroke-width='3'/%3E%3C/svg%3E">
          <title>
            <fmt:message key="site.title" />
          </title>
          <link rel="preconnect" href="https://fonts.googleapis.com">
          <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
          <link
            href="https://fonts.googleapis.com/css2?family=Hind+Siliguri:wght@400;500;600;700&family=Inter:wght@400;500;600;700;800&display=swap"
            rel="stylesheet">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/searchable-select.css">
          <style>
            .home-page {
              --home-red: #ad2430;
              --home-deep: #70121b;
              --home-ink: #26313d;
              --home-muted: #596775;
              --home-line: #e4e8ec;
              background: #fff;
              color: var(--home-ink)
            }

            .home-page .eyebrow {
              color: var(--home-red)
            }

            .home-page h2,
            .home-page h3 {
              color: #27333e
            }

            .home-page :where(a, button, summary, select, input, [tabindex]):focus-visible {
              outline: 3px solid #117966;
              outline-offset: 3px
            }

            .site-header {
              position: sticky;
              top: 0;
              z-index: 50;
              border-bottom: 1px solid #e7e9ed;
              background: rgba(255, 255, 255, .97);
              backdrop-filter: blur(12px)
            }

            .navbar {
              position: relative;
              min-height: 76px;
              gap: 20px
            }

            .nav-links {
              gap: clamp(10px, 1.5vw, 20px)
            }

            .nav-links>a:not(.button),
            .link-button {
              font-size: .88rem
            }

            .menu-toggle {
              border: 1px solid #e4e8ec;
              border-radius: 10px
            }

            .menu-toggle span {
              height: 2px;
              border-radius: 2px
            }

            .home-hero {
              position: relative;
              isolation: isolate;
              overflow: hidden;
              min-height: 520px;
              padding: 72px 0 120px;
              background: linear-gradient(118deg, #631019 0%, #8b1824 48%, #b52c38 100%);
              color: #fff
            }

            .home-hero:before,
            .home-hero:after {
              position: absolute;
              z-index: -1;
              content: "";
              pointer-events: none;
              border: 1px solid rgba(255, 255, 255, .12);
              border-radius: 50%
            }

            .home-hero:before {
              width: 520px;
              height: 520px;
              top: -320px;
              right: -120px;
              box-shadow: 0 0 0 42px rgba(255, 255, 255, .035), 0 0 0 90px rgba(255, 255, 255, .025)
            }

            .home-hero:after {
              width: 420px;
              height: 420px;
              bottom: -300px;
              left: -140px;
              box-shadow: 0 0 0 36px rgba(255, 255, 255, .035), 0 0 0 76px rgba(255, 255, 255, .02)
            }

            .home-hero-pattern {
              position: absolute;
              z-index: -1;
              top: 0;
              right: 20%;
              width: 100px;
              height: 130px;
              border-radius: 55% 45% 60% 40%;
              background: rgba(255, 255, 255, .035);
              transform: rotate(24deg)
            }

            .home-hero-inner {
              position: relative;
              z-index: 1;
              grid-template-columns: minmax(0, 1.2fr) minmax(220px, .8fr);
              gap: 28px 48px
            }

            .home-hero .eyebrow {
              color: #ffd8dc
            }

            .home-hero h1 {
              max-width: 760px;
              margin: 11px 0 16px;
              color: #fff;
              font-size: clamp(2.7rem, 5vw, 4.75rem);
              line-height: 1.06;
              letter-spacing: -.055em
            }

            .home-hero-subtitle {
              max-width: 650px;
              margin: 0;
              color: #ffeff0;
              font-size: clamp(1rem, 1.6vw, 1.18rem);
              line-height: 1.65
            }

            .home-hero .hero-actions {
              gap: 12px;
              margin-top: 24px;
              flex-wrap: wrap
            }

            .home-hero .button-light {
              min-width: 180px;
              color: #ffffff
            }

            .home-hero .button-outline.light-link {
              min-width: 180px;
              border-color: rgba(255, 255, 255, .75);
              background: transparent;
              color: #fff
            }

            .home-hero .button-outline.light-link:hover {
              background: #fff;
              color: #851722
            }

            .home-hero-mark {
              width: min(100%, 270px);
              background: radial-gradient(circle, rgba(255, 255, 255, .11), rgba(255, 255, 255, .015) 66%)
            }

            .home-hero-mark svg {
              width: 39%
            }

            .home-emergency-link {
              display: inline-flex;
              align-items: center;
              gap: 8px;
              margin-top: 18px;
              color: #fff;
              font-size: .91rem;
              font-weight: 750;
              text-decoration: underline;
              text-decoration-color: rgba(255, 255, 255, .65);
              text-underline-offset: 4px
            }

            .home-emergency-link:hover {
              color: #ffe2e5
            }

            #home-search {
              scroll-margin-top: 96px
            }

            .home-search {
              position: relative;
              z-index: 4;
              margin-top: -82px;
              padding: 0 0 27px
            }

            .home-search .search-card {
              width: 100%;
              max-width: none;
              margin: 0;
              padding: 26px 30px 24px;
              border: 1px solid #e8eaed;
              border-radius: 20px;
              background: #fff;
              box-shadow: 0 20px 55px rgba(41, 12, 17, .2)
            }

            .search-card-heading {
              gap: 13px;
              margin-bottom: 8px
            }

            .search-card-heading .icon-circle {
              flex: 0 0 46px
            }

            .search-card-heading .eyebrow {
              margin-bottom: 4px
            }

            .search-card-heading h2 {
              margin: 0;
              font-size: 1.5rem
            }

            .home-search-description {
              margin: 0 0 18px;
              color: var(--home-muted);
              font-size: .94rem
            }

            .home-search-form {
              display: grid;
              grid-template-columns: repeat(4, minmax(0, 1fr)) minmax(145px, .82fr);
              align-items: end;
              gap: 12px
            }

            .home-search-form label {
              display: flex;
              min-width: 0;
              flex-direction: column;
              gap: 6px;
              color: #394652;
              font-size: .85rem;
              font-weight: 750
            }

            .home-search-form .searchable-select,
            .home-search-form .searchable-select__input {
              width: 100%;
              min-width: 0
            }

            .home-search-form .searchable-select__input {
              min-height: 49px;
              border-color: #d3dae0;
              border-radius: 10px
            }

            .home-search-form select {
              width: 100%;
              min-height: 49px
            }

            .home-search-button {
              grid-column: auto;
              min-height: 49px;
              padding-inline: 15px;
              white-space: nowrap
            }

            .home-privacy-note {
              display: flex;
              align-items: flex-start;
              gap: 10px;
              margin: 17px 2px 0;
              color: #596775;
              font-size: .83rem;
              line-height: 1.55
            }

            .home-privacy-note svg {
              flex: 0 0 20px;
              margin-top: 1px;
              color: #087461
            }

            .home-section {
              padding: 58px 0
            }

            .home-section-heading {
              display: flex;
              justify-content: space-between;
              align-items: end;
              gap: 24px;
              margin-bottom: 23px
            }

            .home-section-heading h2 {
              margin: 0
            }

            .home-section-heading p {
              max-width: 520px;
              margin: 0;
              color: var(--home-muted)
            }

            .home-urgent {
              padding-top: 32px;
              background: #fff8f5
            }

            .home-urgent .home-section-heading {
              align-items: center;
              margin-bottom: 18px
            }

            .home-urgent-link {
              display: inline-flex;
              align-items: center;
              gap: 7px;
              flex: 0 0 auto;
              font-size: .9rem;
              font-weight: 800;
              white-space: nowrap
            }

            .home-urgent-list {
              display: grid;
              grid-template-columns: repeat(4, minmax(0, 1fr));
              gap: 13px
            }

            .home-urgent-card {
              display: flex;
              min-width: 0;
              min-height: 92px;
              align-items: center;
              gap: 12px;
              padding: 15px;
              border: 1px solid #edddda;
              border-radius: 14px;
              background: #fff;
              color: var(--home-ink);
              box-shadow: 0 5px 17px rgba(82, 36, 32, .045);
              transition: transform .18s ease, border-color .18s ease, box-shadow .18s ease
            }

            .home-urgent-card:hover {
              transform: translateY(-3px);
              border-color: #d9a5aa;
              box-shadow: 0 12px 25px rgba(82, 36, 32, .1);
              color: var(--home-ink)
            }

            .home-urgent-card .blood-badge {
              flex: 0 0 auto;
              min-width: 48px;
              min-height: 46px;
              border-radius: 12px;
              font-size: 1rem
            }

            .home-urgent-detail {
              display: grid;
              min-width: 0;
              gap: 5px
            }

            .home-urgent-district {
              overflow: hidden;
              font-weight: 800;
              text-overflow: ellipsis;
              white-space: nowrap
            }

            .home-urgent-time {
              display: flex;
              flex-wrap: wrap;
              gap: 4px;
              color: #596775;
              font-size: .76rem
            }

            .home-live-stats {
              padding: 22px 0;
              background: #fff
            }

            .home-live-stats-grid {
              display: grid;
              grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
              overflow: hidden;
              border: 1px solid var(--home-line);
              border-radius: 17px;
              background: #fff;
              box-shadow: 0 8px 24px rgba(32, 38, 46, .045)
            }

            .home-live-stat {
              display: grid;
              gap: 5px;
              padding: 21px 25px;
              border-right: 1px solid var(--home-line)
            }

            .home-live-stat:last-child {
              border: 0
            }

            .home-live-stat dt {
              order: 2;
              color: var(--home-muted);
              font-size: .86rem;
              font-weight: 650
            }

            .home-live-stat dd {
              order: 1;
              margin: 0;
              color: var(--home-red);
              font-size: clamp(1.6rem, 3vw, 2.2rem);
              font-weight: 850;
              line-height: 1.1
            }

            .home-how {
              background: #f5f7f8
            }

            .home-steps-grid {
              display: grid;
              grid-template-columns: repeat(3, minmax(0, 1fr));
              gap: 16px
            }

            .home-step-card {
              position: relative;
              min-height: 185px;
              padding: 23px;
              border: 1px solid var(--home-line);
              border-radius: 16px;
              background: #fff;
              box-shadow: 0 8px 23px rgba(32, 38, 46, .045)
            }

            .home-step-icon {
              display: grid;
              width: 46px;
              height: 46px;
              place-items: center;
              margin-bottom: 17px;
              border-radius: 13px;
              background: #fff0f1;
              color: #a51e2b
            }

            .home-step-icon svg {
              width: 23px;
              height: 23px
            }

            .home-step-card:nth-child(2) .home-step-icon {
              background: #e6f5f1;
              color: #087461
            }

            .home-step-no {
              position: absolute;
              top: 20px;
              right: 21px;
              color: #82909c;
              font-size: .78rem;
              font-weight: 800
            }

            .home-step-card h3 {
              margin: 0 0 7px;
              font-size: 1.06rem
            }

            .home-step-card p {
              margin: 0;
              color: var(--home-muted);
              font-size: .9rem;
              line-height: 1.6
            }

            .home-feature-grid {
              display: grid;
              grid-template-columns: repeat(2, minmax(0, 1fr));
              align-items: stretch;
              gap: 18px
            }

            .home-feature-card {
              min-width: 0;
              padding: 25px;
              border: 1px solid var(--home-line);
              border-radius: 17px;
              background: #fff;
              box-shadow: 0 8px 25px rgba(32, 38, 46, .05)
            }

            .home-feature-card h2 {
              margin: 0 0 9px;
              font-size: 1.45rem
            }

            .home-feature-card .eyebrow {
              margin-bottom: 8px
            }

            .home-feature-intro {
              margin: 0 0 18px;
              color: var(--home-muted);
              font-size: .91rem;
              line-height: 1.6
            }

            .home-eligibility-list {
              display: grid;
              gap: 10px;
              margin: 0;
              padding: 0;
              list-style: none
            }

            .home-eligibility-list li {
              display: flex;
              align-items: center;
              gap: 11px;
              padding: 11px 12px;
              border: 1px solid #e9edef;
              border-radius: 12px;
              background: #fbfcfc;
              color: #34414d;
              font-size: .91rem;
              font-weight: 700
            }

            .home-check-icon {
              display: grid;
              width: 30px;
              height: 30px;
              flex: 0 0 30px;
              place-items: center;
              border-radius: 9px;
              background: #e7f5f1;
              color: #087461
            }

            .home-check-icon svg {
              width: 17px;
              height: 17px
            }

            .home-table-wrap {
              overflow-x: auto;
              border: 1px solid var(--home-line);
              border-radius: 12px;
              background: #fff;
              -webkit-overflow-scrolling: touch
            }

            .home-compatibility-table {
              width: 100%;
              min-width: 350px;
              border-collapse: collapse;
              text-align: left;
              font-size: .83rem
            }

            .home-compatibility-table caption {
              padding: 12px 13px;
              text-align: left;
              color: var(--home-muted);
              font-size: .82rem
            }

            .home-compatibility-table th,
            .home-compatibility-table td {
              padding: 9px 12px;
              border-top: 1px solid #edf0f2;
              vertical-align: top
            }

            .home-compatibility-table thead th {
              border-top: 0;
              background: #fff0f1;
              color: #791821;
              font-size: .8rem
            }

            .home-compatibility-table tbody th {
              width: 92px;
              color: #303c47;
              font-weight: 850
            }

            .home-compatibility-table tbody tr:nth-child(even) {
              background: #fafbfc
            }

            .home-blood-code {
              display: inline-flex;
              min-width: 39px;
              justify-content: center;
              padding: 3px 7px;
              border-radius: 7px;
              background: #fff0f1;
              color: #9f1e2b;
              font-weight: 850
            }

            .home-faq {
              background: #fff
            }

            .home-faq-list {
              display: grid;
              max-width: 960px;
              gap: 10px
            }

            .home-faq-list details {
              border: 1px solid var(--home-line);
              border-radius: 13px;
              background: #fff;
              box-shadow: 0 4px 14px rgba(32, 38, 46, .035)
            }

            .home-faq-list summary {
              position: relative;
              padding: 16px 53px 16px 18px;
              color: #2d3843;
              font-weight: 800;
              cursor: pointer;
              list-style: none
            }

            .home-faq-list summary::-webkit-details-marker {
              display: none
            }

            .home-faq-list summary:after {
              position: absolute;
              top: 50%;
              right: 17px;
              display: grid;
              width: 26px;
              height: 26px;
              place-items: center;
              transform: translateY(-50%);
              border-radius: 50%;
              background: #fff0f1;
              color: #a51e2b;
              content: "+";
              font-size: 1.1rem
            }

            .home-faq-list details[open] summary:after {
              content: "−"
            }

            .home-faq-answer {
              margin: 0;
              padding: 0 18px 17px;
              color: var(--home-muted);
              font-size: .93rem;
              line-height: 1.65
            }

            .site-footer {
              padding: 48px 0 18px;
              background: #20262e;
              color: #d9e0e5
            }

            .home-footer-grid {
              display: grid;
              grid-template-columns: 1.5fr 1fr 1fr;
              gap: 38px;
              padding-bottom: 30px
            }

            .home-footer-brand {
              margin-bottom: 12px;
              color: #fff
            }

            .home-footer-brand .brand-light {
              color: #d9e0e5
            }

            .home-footer-about p {
              max-width: 360px;
              margin: 0 0 13px;
              color: #c1cbd3;
              font-size: .91rem
            }

            .home-footer-grid h2 {
              margin: 5px 0 14px;
              color: #fff;
              font-size: 1rem;
              letter-spacing: 0
            }

            .home-footer-links,
            .home-footer-contact {
              display: flex;
              flex-direction: column;
              align-items: flex-start;
              gap: 10px
            }

            .home-footer-grid a:not(.brand) {
              color: #d2dbe1;
              font-size: .9rem
            }

            .home-footer-grid a:hover {
              color: #fff;
              text-decoration: underline;
              text-underline-offset: 3px
            }

            .home-footer-contact p {
              margin: 6px 0 0;
              color: #d7c4c5;
              font-size: .83rem;
              line-height: 1.55
            }

            .home-footer-bottom {
              border-top: 1px solid #414a53;
              padding-top: 14px;
              color: #bdc7cf;
              font-size: .8rem
            }

            .home-sr-only {
              position: absolute !important;
              width: 1px !important;
              height: 1px !important;
              padding: 0 !important;
              margin: -1px !important;
              overflow: hidden !important;
              clip: rect(0, 0, 0, 0) !important;
              white-space: nowrap !important;
              border: 0 !important
            }

            @media(max-width:1050px) {
              .home-urgent-list {
                grid-template-columns: repeat(2, minmax(0, 1fr))
              }

              .home-search-form {
                grid-template-columns: repeat(2, minmax(0, 1fr))
              }

              .home-search-button {
                grid-column: 1/-1
              }
            }

            @media(max-width:980px) {
              .navbar {
                min-height: 68px
              }

              .menu-toggle {
                display: block
              }

              .nav-links {
                display: none;
                position: absolute;
                top: calc(100% - 1px);
                left: 0;
                right: 0;
                max-height: calc(100vh - 68px);
                overflow-y: auto;
                align-items: stretch;
                gap: 0;
                padding: 12px 20px 18px;
                border: 1px solid #e6e9ed;
                border-top: 0;
                border-radius: 0 0 14px 14px;
                background: #fff;
                box-shadow: 0 15px 24px rgba(31, 35, 40, .12);
                flex-direction: column
              }

              .nav-links.is-open {
                display: flex
              }

              .nav-links>a:not(.button),
              .nav-links .link-button {
                padding: 10px 3px;
                text-align: left
              }

              .nav-links .button {
                margin-top: 7px
              }

              .nav-logout {
                padding: 10px 3px
              }

              .language-switch {
                align-self: flex-start;
                margin-top: 10px
              }

              .home-hero {
                min-height: 0;
                padding: 60px 0 108px
              }

              .home-hero-inner {
                grid-template-columns: minmax(0, 1.2fr) minmax(180px, .8fr);
                gap: 25px
              }

              .home-hero-mark {
                width: 210px
              }

              .home-search {
                margin-top: -68px
              }

              .home-section {
                padding: 52px 0
              }

              .home-urgent {
                padding-top: 30px
              }

              .home-feature-card {
                padding: 21px
              }

              .home-footer-grid {
                gap: 24px
              }
            }

            @media(max-width:700px) {
              .home-hero {
                padding: 48px 0 88px
              }

              .home-hero-inner {
                grid-template-columns: 1fr;
                gap: 18px
              }

              .home-hero-mark {
                display: none
              }

              .home-hero h1 {
                font-size: clamp(2.35rem, 10vw, 3.35rem)
              }

              .home-hero .hero-actions {
                align-items: stretch;
                flex-direction: column
              }

              .home-hero .hero-actions .button {
                width: 100%
              }

              .home-search {
                margin-top: -48px;
                padding-bottom: 12px
              }

              .home-search .search-card {
                padding: 20px
              }

              .home-section {
                padding: 44px 0
              }

              .home-section-heading {
                align-items: flex-start;
                flex-direction: column;
                gap: 10px
              }

              .home-urgent {
                padding-top: 25px
              }

              .home-steps-grid {
                grid-template-columns: 1fr
              }

              .home-feature-grid {
                grid-template-columns: 1fr
              }

              .home-footer-grid {
                grid-template-columns: 1fr;
                gap: 25px
              }

              .home-footer-about p {
                max-width: none
              }
            }

            @media(max-width:480px) {
              .container {
                width: calc(100% - 28px)
              }

              .home-search-form {
                grid-template-columns: 1fr;
                gap: 11px
              }

              .home-search-button {
                grid-column: 1
              }

              .home-urgent-list {
                grid-template-columns: 1fr
              }

              .home-urgent-card {
                min-height: 78px;
                padding: 13px
              }

              .home-live-stats {
                padding: 14px 0
              }

              .home-live-stats-grid {
                grid-template-columns: 1fr
              }

              .home-live-stat {
                grid-template-columns: 1fr auto;
                align-items: center;
                padding: 14px 17px;
                border-right: 0;
                border-bottom: 1px solid var(--home-line)
              }

              .home-live-stat:last-child {
                border-bottom: 0
              }

              .home-live-stat dt {
                order: 1
              }

              .home-live-stat dd {
                order: 2;
                font-size: 1.45rem
              }

              .home-feature-card {
                padding: 17px
              }

              .home-faq-list summary {
                padding: 15px 47px 15px 15px
              }

              .home-faq-answer {
                padding: 0 15px 15px
              }

              .home-hero h1 {
                font-size: 2.35rem
              }
            }

            @media(prefers-reduced-motion:reduce) {
              .home-urgent-card {
                transition: none
              }
            }
          </style>
        </head>

        <body data-context-path="${pageContext.request.contextPath}">
          <a class="skip-link" href="#main">
            <fmt:message key="nav.skip" />
          </a>
          <header class="site-header">
            <nav class="navbar container" aria-label="<fmt:message key='nav.label'/>">
              <a class="brand" href="${pageContext.request.contextPath}/"
                aria-label="<fmt:message key='site.homeAlt'/>">
                <svg class="brand-mark" viewBox="0 0 40 48" role="img" aria-label="<fmt:message key='site.dropAlt'/>">
                  <path d="M20 2C15 11 5 22 5 31a15 15 0 0 0 30 0C35 22 25 11 20 2Z" fill="currentColor" />
                  <path d="M13 31c0 4 3 7 7 8" fill="none" stroke="#fff" stroke-linecap="round" stroke-width="3" />
                </svg>
                <span>Blood<span class="brand-light">Link</span></span>
              </a>
              <button class="menu-toggle" type="button" aria-expanded="false" aria-controls="main-menu"
                aria-label="<fmt:message key='nav.open'/>"><span></span><span></span><span></span></button>
              <div class="nav-links" id="main-menu">
                <a href="${pageContext.request.contextPath}/">
                  <fmt:message key="nav.home" />
                </a>
                <a href="${pageContext.request.contextPath}/search">
                  <fmt:message key="nav.findDonor" />
                </a>
                <a href="${pageContext.request.contextPath}/requests">
                  <fmt:message key="nav.requests" />
                </a>
                <a href="${pageContext.request.contextPath}/about.jsp">
                  <fmt:message key="nav.about" />
                </a>
                <a href="${pageContext.request.contextPath}/contact.jsp">
                  <fmt:message key="nav.contact" />
                </a>
                <a class="button button-small nav-donate" href="${pageContext.request.contextPath}/donate.jsp">
                  <fmt:message key="nav.donate" />
                </a>
                <c:choose>
                  <c:when test="${not empty sessionScope.donorId}">
                    <a href="${pageContext.request.contextPath}/user/dashboard">
                      <fmt:message key="nav.dashboard" />
                    </a>
                    <form class="nav-logout" method="post" action="${pageContext.request.contextPath}/logout"><input
                        type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>" /><button
                        class="link-button" type="submit">
                        <fmt:message key="nav.logout" />
                      </button></form>
                  </c:when>
                  <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">
                      <fmt:message key="nav.login" />
                    </a>
                    <a class="button button-small" href="${pageContext.request.contextPath}/register">
                      <fmt:message key="nav.register" />
                    </a>
                  </c:otherwise>
                </c:choose>
                <div class="language-switch" role="group" aria-label="<fmt:message key='language.label'/>"><a
                    href="?lang=bn" lang="bn" <c:if test="${sessionScope.bloodlinkLocale eq 'bn'}">aria-current="page"
                    </c:if>>
                    <fmt:message key="language.bangla" />
                  </a><span aria-hidden="true">|</span><a href="?lang=en" lang="en" <c:if
                    test="${sessionScope.bloodlinkLocale eq 'en'}">aria-current="page"</c:if>>
                    <fmt:message key="language.english" />
                  </a></div>
              </div>
            </nav>
          </header>

          <main id="main" class="page-main home-page">
            <section class="home-hero" aria-labelledby="home-hero-title">
              <div class="home-hero-pattern" aria-hidden="true"></div>
              <div class="container home-hero-inner">
                <div class="home-hero-copy">
                  <p class="eyebrow">
                    <fmt:message key="home.hero.eyebrow" />
                  </p>
                  <h1 id="home-hero-title">
                    <fmt:message key="home.hero.title" />
                  </h1>
                  <p class="home-hero-subtitle">
                    <fmt:message key="home.hero.subtitle" />
                  </p>
                  <div class="hero-actions">
                    <a class="button button-light" href="${pageContext.request.contextPath}/register">
                      <fmt:message key="home.hero.join" />
                    </a>
                    <a class="button button-outline light-link" href="${pageContext.request.contextPath}/requests">
                      <fmt:message key="home.hero.requests" />
                    </a>
                  </div>
                  <a class="home-emergency-link" href="#home-search"><svg viewBox="0 0 24 24" width="18" height="18"
                      fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                      aria-hidden="true">
                      <circle cx="11" cy="11" r="7" />
                      <path d="m16 16 5 5" />
                    </svg>
                    <fmt:message key="home.hero.emergency" />
                  </a>
                </div>
                <div class="home-hero-mark" aria-hidden="true"><span class="drop-orbit drop-orbit-one"></span><span
                    class="drop-orbit drop-orbit-two"></span><svg viewBox="0 0 120 144" focusable="false">
                    <path d="M60 4C46 30 14 66 14 94a46 46 0 0 0 92 0C106 66 74 30 60 4Z" fill="currentColor" />
                    <path d="M39 93c0 12 9 22 21 24" fill="none" stroke="white" stroke-linecap="round" stroke-width="8"
                      opacity=".65" />
                  </svg></div>
              </div>
            </section>

            <section id="home-search" class="home-search" aria-labelledby="home-search-title">
              <div class="container">
                <div class="search-card">
                  <div class="search-card-heading"><span class="icon-circle" aria-hidden="true"><svg viewBox="0 0 24 24"
                        width="24" height="24" fill="none" stroke="currentColor" stroke-width="2"
                        stroke-linecap="round">
                        <circle cx="10.8" cy="10.8" r="6.8" />
                        <path d="m16 16 5 5" />
                      </svg></span>
                    <div>
                      <p class="eyebrow">
                        <fmt:message key="home.search.eyebrow" />
                      </p>
                      <h2 id="home-search-title">
                        <fmt:message key="home.search.title" />
                      </h2>
                    </div>
                  </div>
                  <p class="home-search-description">
                    <fmt:message key="home.search.description" />
                  </p>
                  <form class="home-search-form" action="${pageContext.request.contextPath}/search" method="get">
                    <label>
                      <fmt:message key="home.label.bloodGroup" />
                      <select name="bloodGroup" data-searchable data-search-placeholder="${msgSearchPlaceholder}"
                        data-search-no-results="${msgSearchNoResults}" data-search-required="${msgSearchRequired}">
                        <option value="">
                          <fmt:message key="select.anyBlood" />
                        </option>
                        <option>A+</option>
                        <option>A-</option>
                        <option>B+</option>
                        <option>B-</option>
                        <option>AB+</option>
                        <option>AB-</option>
                        <option>O+</option>
                        <option>O-</option>
                      </select>
                    </label>
                    <label>
                      <fmt:message key="home.label.division" />
                      <select id="homeDivision" data-searchable data-division-filter="districtId"
                        data-search-placeholder="${msgSearchPlaceholder}"
                        data-search-no-results="${msgSearchNoResults}">
                        <option value="">
                          <fmt:message key="select.allDivisions" />
                        </option>
                        <option value="Dhaka">
                          <fmt:message key="division.dhaka" />
                        </option>
                        <option value="Chattogram">
                          <fmt:message key="division.chattogram" />
                        </option>
                        <option value="Rajshahi">
                          <fmt:message key="division.rajshahi" />
                        </option>
                        <option value="Khulna">
                          <fmt:message key="division.khulna" />
                        </option>
                        <option value="Barishal">
                          <fmt:message key="division.barishal" />
                        </option>
                        <option value="Sylhet">
                          <fmt:message key="division.sylhet" />
                        </option>
                        <option value="Rangpur">
                          <fmt:message key="division.rangpur" />
                        </option>
                        <option value="Mymensingh">
                          <fmt:message key="division.mymensingh" />
                        </option>
                      </select>
                    </label>
                    <label>
                      <fmt:message key="home.label.district" />
                      <select id="districtId" name="districtId" data-searchable
                        data-search-placeholder="${msgSearchPlaceholder}" data-search-no-results="${msgSearchNoResults}"
                        data-search-required="${msgSearchRequired}">
                        <option value="">
                          <fmt:message key="select.anyDistrict" />
                        </option>
                        <c:forEach var="d" items="${districts}">
                          <option value="${d.districtId}" data-division="${d.division}">
                            <c:out value="${d.name}" />
                          </option>
                        </c:forEach>
                      </select>
                    </label>
                    <label>
                      <fmt:message key="home.label.upazila" /> <span class="optional">
                        <fmt:message key="common.optional" />
                      </span>
                      <select id="upazilaSelect" name="upazilaId" data-searchable data-district-source="districtId"
                        data-search-placeholder="${msgSearchPlaceholder}" data-search-no-results="${msgSearchNoResults}"
                        data-upazila-any="${msgAnyUpazila}" data-upazila-choose="${msgChooseDistrictFirst}"
                        data-upazila-loading="${msgUpazilaLoading}" data-upazila-none="${msgNoUpazilas}"
                        data-upazila-error="${msgUpazilaLoadError}" disabled>
                        <option value="">
                          <fmt:message key="select.chooseDistrictFirst" />
                        </option>
                      </select>
                    </label>
                    <button class="button home-search-button" type="submit">
                      <fmt:message key="home.search.submit" />
                    </button>
                  </form>
                  <p class="home-privacy-note"><svg viewBox="0 0 24 24" width="20" height="20" fill="none"
                      stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"
                      aria-hidden="true">
                      <rect x="4" y="10" width="16" height="11" rx="2" />
                      <path d="M8 10V7a4 4 0 0 1 8 0v3M12 14v3" />
                    </svg><span>
                      <fmt:message key="home.search.privacy" />
                    </span></p>
                </div>
              </div>
            </section>

            <c:if test="${not empty latestRequests}">
              <section class="home-section home-urgent" aria-labelledby="home-urgent-title">
                <div class="container">
                  <div class="home-section-heading">
                    <div>
                      <p class="eyebrow">
                        <fmt:message key="home.urgent.eyebrow" />
                      </p>
                      <h2 id="home-urgent-title">
                        <fmt:message key="home.urgent.title" />
                      </h2>
                    </div><a class="home-urgent-link" href="${pageContext.request.contextPath}/requests">
                      <fmt:message key="home.urgent.viewAll" /><span aria-hidden="true">→</span>
                    </a>
                  </div>
                  <div class="home-urgent-list" data-just-now="<fmt:message key='home.time.justNow'/>"
                    data-minute-ago="<fmt:message key='home.time.minuteAgo'/>"
                    data-minutes-ago="<fmt:message key='home.time.minutesAgo'/>"
                    data-hour-ago="<fmt:message key='home.time.hourAgo'/>"
                    data-hours-ago="<fmt:message key='home.time.hoursAgo'/>"
                    data-day-ago="<fmt:message key='home.time.dayAgo'/>"
                    data-days-ago="<fmt:message key='home.time.daysAgo'/>">
                    <c:forEach var="r" items="${latestRequests}">
                      <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="requestCreatedIso" />
                      <a class="home-urgent-card" href="${pageContext.request.contextPath}/requests">
                        <span class="blood-badge">
                          <c:out value="${r.bloodGroup}" />
                        </span>
                        <span class="home-urgent-detail"><span class="home-urgent-district">
                            <c:out value="${r.districtName}" />
                          </span><span class="home-urgent-time"><span>
                              <fmt:message key="home.urgent.posted" />
                            </span><time class="home-timeago" datetime="<c:out value='${requestCreatedIso}'/>"
                              data-created-at="${r.createdAt.time}">
                              <fmt:formatDate value="${r.createdAt}" pattern="MMM d, yyyy h:mm a" />
                            </time></span></span>
                      </a>
                    </c:forEach>
                  </div>
                </div>
              </section>
            </c:if>

            <c:if test="${approvedDonors ne null or openRequests ne null or districts ne null}">
              <section class="home-live-stats" aria-labelledby="home-stats-title">
                <div class="container">
                  <h2 id="home-stats-title" class="home-sr-only">
                    <fmt:message key="home.stats.label" />
                  </h2>
                  <dl class="home-live-stats-grid">
                    <c:if test="${approvedDonors ne null}">
                      <div class="home-live-stat">
                        <dt>
                          <fmt:message key="home.stats.approvedDonors" />
                        </dt>
                        <dd>
                          <c:out value="${approvedDonors}" />
                        </dd>
                      </div>
                    </c:if>
                    <c:if test="${openRequests ne null}">
                      <div class="home-live-stat">
                        <dt>
                          <fmt:message key="home.stats.requests" />
                        </dt>
                        <dd>
                          <c:out value="${openRequests}" />
                        </dd>
                      </div>
                    </c:if>
                    <c:if test="${districts ne null}">
                      <div class="home-live-stat">
                        <dt>
                          <fmt:message key="home.stats.districts" />
                        </dt>
                        <dd>
                          <c:out value="${fn:length(districts)}" />
                        </dd>
                      </div>
                    </c:if>
                  </dl>
                </div>
              </section>
            </c:if>

            <section class="home-section home-how" aria-labelledby="home-steps-title">
              <div class="container">
                <div class="home-section-heading">
                  <div>
                    <p class="eyebrow">
                      <fmt:message key="home.steps.eyebrow" />
                    </p>
                    <h2 id="home-steps-title">
                      <fmt:message key="home.steps.title" />
                    </h2>
                  </div>
                </div>
                <div class="home-steps-grid">
                  <article class="home-step-card"><span class="home-step-no">01</span><span class="home-step-icon"
                      aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                        stroke-linecap="round">
                        <circle cx="10.8" cy="10.8" r="6.8" />
                        <path d="m16 16 5 5" />
                      </svg></span>
                    <h3>
                      <fmt:message key="home.steps.search.title" />
                    </h3>
                    <p>
                      <fmt:message key="home.steps.search.body" />
                    </p>
                  </article>
                  <article class="home-step-card"><span class="home-step-no">02</span><span class="home-step-icon"
                      aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                        stroke-linecap="round" stroke-linejoin="round">
                        <path
                          d="M6.5 3.5 9 3l2 4-2 2a15 15 0 0 0 6 6l2-2 4 2-.5 2.5c-.2 1.2-1.3 2-2.5 2A15 15 0 0 1 4.5 6c0-1.2.8-2.3 2-2.5Z" />
                      </svg></span>
                    <h3>
                      <fmt:message key="home.steps.contact.title" />
                    </h3>
                    <p>
                      <fmt:message key="home.steps.contact.body" />
                    </p>
                  </article>
                  <article class="home-step-card"><span class="home-step-no">03</span><span class="home-step-icon"
                      aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                        stroke-linecap="round" stroke-linejoin="round">
                        <path
                          d="M20.8 8.7c0 5.1-8.8 10.3-8.8 10.3S3.2 13.8 3.2 8.7A4.7 4.7 0 0 1 12 6.4a4.7 4.7 0 0 1 8.8 2.3Z" />
                      </svg></span>
                    <h3>
                      <fmt:message key="home.steps.save.title" />
                    </h3>
                    <p>
                      <fmt:message key="home.steps.save.body" />
                    </p>
                  </article>
                </div>
              </div>
            </section>

            <section class="home-section">
              <div class="container home-feature-grid">
                <article class="home-feature-card" aria-labelledby="home-eligibility-title">
                  <p class="eyebrow">
                    <fmt:message key="home.eligibility.eyebrow" />
                  </p>
                  <h2 id="home-eligibility-title">
                    <fmt:message key="home.eligibility.title" />
                  </h2>
                  <p class="home-feature-intro">
                    <fmt:message key="home.eligibility.intro" />
                  </p>
                  <ul class="home-eligibility-list">
                    <li><span class="home-check-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <path d="M12 3 5 6v5c0 4.5 2.8 8 7 10 4.2-2 7-5.5 7-10V6l-7-3Z" />
                          <path d="m9 12 2 2 4-4" />
                        </svg></span>
                      <fmt:message key="home.eligibility.age" />
                    </li>
                    <li><span class="home-check-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <path d="M4 19h16M6 16V5h12v11M9 9h6M9 12h6" />
                          <path d="M9 16v3m6-3v3" />
                        </svg></span>
                      <fmt:message key="home.eligibility.weight" />
                    </li>
                    <li><span class="home-check-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="2" stroke-linecap="round">
                          <circle cx="12" cy="12" r="9" />
                          <path d="M12 7v5l3 2" />
                        </svg></span>
                      <fmt:message key="home.eligibility.gap" />
                    </li>
                    <li><span class="home-check-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <path
                            d="M20.8 8.7c0 5.1-8.8 10.3-8.8 10.3S3.2 13.8 3.2 8.7A4.7 4.7 0 0 1 12 6.4a4.7 4.7 0 0 1 8.8 2.3Z" />
                          <path d="M8.5 11.5h2l1-2 1.8 4 1-2h1.2" />
                        </svg></span>
                      <fmt:message key="home.eligibility.health" />
                    </li>
                  </ul>
                </article>

                <article class="home-feature-card" aria-labelledby="home-compatibility-title">
                  <p class="eyebrow">
                    <fmt:message key="home.compatibility.eyebrow" />
                  </p>
                  <h2 id="home-compatibility-title">
                    <fmt:message key="home.compatibility.title" />
                  </h2>
                  <p class="home-feature-intro">
                    <fmt:message key="home.compatibility.intro" />
                  </p>
                  <div class="home-table-wrap" role="region" tabindex="0"
                    aria-label="<fmt:message key='home.compatibility.caption'/>">
                    <table class="home-compatibility-table">
                      <caption>
                        <fmt:message key="home.compatibility.caption" />
                      </caption>
                      <thead>
                        <tr>
                          <th scope="col">
                            <fmt:message key="home.compatibility.donorType" />
                          </th>
                          <th scope="col">
                            <fmt:message key="home.compatibility.recipientTypes" />
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <th scope="row"><span class="home-blood-code">O-</span></th>
                          <td>O-, O+, A-, A+, B-, B+, AB-, AB+</td>
                        </tr>
                        <tr>
                          <th scope="row"><span class="home-blood-code">O+</span></th>
                          <td>O+, A+, B+, AB+</td>
                        </tr>
                        <tr>
                          <th scope="row"><span class="home-blood-code">A-</span></th>
                          <td>A-, A+, AB-, AB+</td>
                        </tr>
                        <tr>
                          <th scope="row"><span class="home-blood-code">A+</span></th>
                          <td>A+, AB+</td>
                        </tr>
                        <tr>
                          <th scope="row"><span class="home-blood-code">B-</span></th>
                          <td>B-, B+, AB-, AB+</td>
                        </tr>
                        <tr>
                          <th scope="row"><span class="home-blood-code">B+</span></th>
                          <td>B+, AB+</td>
                        </tr>
                        <tr>
                          <th scope="row"><span class="home-blood-code">AB-</span></th>
                          <td>AB-, AB+</td>
                        </tr>
                        <tr>
                          <th scope="row"><span class="home-blood-code">AB+</span></th>
                          <td>AB+</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </article>
              </div>
            </section>

            <section class="home-section home-faq" aria-labelledby="home-faq-title">
              <div class="container">
                <div class="home-section-heading">
                  <div>
                    <p class="eyebrow">
                      <fmt:message key="home.faq.eyebrow" />
                    </p>
                    <h2 id="home-faq-title">
                      <fmt:message key="home.faq.title" />
                    </h2>
                  </div>
                </div>
                <div class="home-faq-list">
                  <details>
                    <summary>
                      <fmt:message key="home.faq.q1" />
                    </summary>
                    <p class="home-faq-answer">
                      <fmt:message key="home.faq.a1" />
                    </p>
                  </details>
                  <details>
                    <summary>
                      <fmt:message key="home.faq.q2" />
                    </summary>
                    <p class="home-faq-answer">
                      <fmt:message key="home.faq.a2" />
                    </p>
                  </details>
                  <details>
                    <summary>
                      <fmt:message key="home.faq.q3" />
                    </summary>
                    <p class="home-faq-answer">
                      <fmt:message key="home.faq.a3" />
                    </p>
                  </details>
                  <details>
                    <summary>
                      <fmt:message key="home.faq.q4" />
                    </summary>
                    <p class="home-faq-answer">
                      <fmt:message key="home.faq.a4" />
                    </p>
                  </details>
                  <details>
                    <summary>
                      <fmt:message key="home.faq.q5" />
                    </summary>
                    <p class="home-faq-answer">
                      <fmt:message key="home.faq.a5" />
                    </p>
                  </details>
                  <details>
                    <summary>
                      <fmt:message key="home.faq.q6" />
                    </summary>
                    <p class="home-faq-answer">
                      <fmt:message key="home.faq.a6" />
                    </p>
                  </details>
                </div>
              </div>
            </section>
          </main>

          <footer class="site-footer">
            <div class="container home-footer-grid">
              <div class="home-footer-about">
                <a class="brand home-footer-brand" href="${pageContext.request.contextPath}/"
                  aria-label="<fmt:message key='site.homeAlt'/>"><svg class="brand-mark" viewBox="0 0 40 48"
                    aria-hidden="true">
                    <path d="M20 2C15 11 5 22 5 31a15 15 0 0 0 30 0C35 22 25 11 20 2Z" fill="currentColor" />
                  </svg><span>Blood<span class="brand-light">Link</span></span></a>
                <h2>
                  <fmt:message key="home.footer.aboutHeading" />
                </h2>
                <p>
                  <fmt:message key="footer.description" />
                </p>
                <a href="${pageContext.request.contextPath}/about.jsp">
                  <fmt:message key="nav.about" />
                </a>
              </div>
              <nav class="home-footer-links" aria-label="<fmt:message key='home.footer.quickLinks'/>">
                <h2>
                  <fmt:message key="home.footer.quickLinks" />
                </h2>
                <a href="${pageContext.request.contextPath}/search">
                  <fmt:message key="footer.findDonor" />
                </a>
                <a href="${pageContext.request.contextPath}/requests">
                  <fmt:message key="footer.openRequests" />
                </a>
                <a href="${pageContext.request.contextPath}/request">
                  <fmt:message key="footer.postRequest" />
                </a>
              </nav>
              <div class="home-footer-contact">
                <h2>
                  <fmt:message key="footer.contactHeading" />
                </h2>
                <a href="mailto:<c:out value='${homeContactEmail}'/>">
                  <fmt:message key="contact.emailLabel" />:
                  <fmt:message key="contact.email" />
                </a>
                <a href="tel:<c:out value='${homeContactPhoneHref}'/>">
                  <fmt:message key="contact.phoneLabel" />:
                  <fmt:message key="contact.phone" />
                </a>
                <p>
                  <fmt:message key="contact.urgentNote" />
                </p>
              </div>
            </div>
            <div class="container home-footer-bottom">
              <fmt:message key="footer.copyright" />
            </div>
          </footer>
          <script src="${pageContext.request.contextPath}/assets/js/app.js" defer></script>
          <script src="${pageContext.request.contextPath}/assets/js/searchable-select.js" defer></script>
          <script>
            (function () {
              var list = document.querySelector('.home-urgent-list');
              if (!list) return;
              var now = Date.now();
              list.querySelectorAll('.home-timeago').forEach(function (node) {
                var createdAt = Number(node.dataset.createdAt);
                if (!Number.isFinite(createdAt)) return;
                var minutes = Math.floor(Math.max(0, now - createdAt) / 60000);
                if (minutes < 1) {
                  node.textContent = list.dataset.justNow;
                } else if (minutes < 60) {
                  node.textContent = minutes + ' ' + (minutes === 1 ? list.dataset.minuteAgo : list.dataset.minutesAgo);
                } else {
                  var hours = Math.floor(minutes / 60);
                  if (hours < 24) node.textContent = hours + ' ' + (hours === 1 ? list.dataset.hourAgo : list.dataset.hoursAgo);
                  else {
                    var days = Math.floor(hours / 24);
                    node.textContent = days + ' ' + (days === 1 ? list.dataset.dayAgo : list.dataset.daysAgo);
                  }
                }
              });
            }());
          </script>
        </body>

        </html>