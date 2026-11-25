<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ include file="/WEB-INF/jspf/lang.jspf" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
      <header class="site-header">
        <nav class="navbar container" aria-label="${msgNavLabel}">
          <a class="brand" href="${pageContext.request.contextPath}/" aria-label="${msgSiteHomeAlt}">
            <svg class="brand-mark" viewBox="0 0 40 48" role="img" aria-label="${msgSiteDropAlt}">
              <path d="M20 2C15 11 5 22 5 31a15 15 0 0 0 30 0C35 22 25 11 20 2Z" fill="currentColor" />
              <path d="M13 31c0 4 3 7 7 8" fill="none" stroke="#fff" stroke-linecap="round" stroke-width="3" />
            </svg>
            <span>Blood<span class="brand-light">Link</span></span>
          </a>
          <button class="menu-toggle" type="button" aria-expanded="false" aria-controls="main-menu"
            aria-label="${msgNavOpen}"><span></span><span></span><span></span></button>
          <div class="nav-links" id="main-menu">
            <a href="${pageContext.request.contextPath}/">
              <fmt:message key="nav.home" />
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
                    type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>"><button class="link-button"
                    type="submit">
                    <fmt:message key="nav.logout" />
                  </button></form>
              </c:when>
              <c:otherwise><a href="${pageContext.request.contextPath}/login">
                  <fmt:message key="nav.login" />
                </a><a class="button button-small" href="${pageContext.request.contextPath}/register">
                  <fmt:message key="nav.becomeDonor" />
                </a></c:otherwise>
            </c:choose>
            <div class="language-switch" role="group" aria-label="${msgLanguageLabel}"><a href="?lang=bn" lang="bn"
                <c:if test="${sessionScope.bloodlinkLocale eq 'bn'}">aria-current="page"</c:if>>
                <fmt:message key="language.bangla" />
              </a><span aria-hidden="true">|</span><a href="?lang=en" lang="en" <c:if
                test="${sessionScope.bloodlinkLocale eq 'en'}">aria-current="page"</c:if>>
                <fmt:message key="language.english" />
              </a></div>
          </div>
        </nav>
      </header>