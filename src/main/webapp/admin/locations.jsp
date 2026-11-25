<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ include file="/WEB-INF/jspf/lang.jspf" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <c:set var="pageTitleKey" scope="request" value="page.adminLocations" />
        <jsp:include page="/admin/includes/header.jsp" />

        <div class="admin-page-heading">
          <div>
            <p class="eyebrow">
              <fmt:message key="adminLocations.eyebrow" />
            </p>
            <h1>
              <fmt:message key="adminLocations.heading" />
            </h1>
            <p>
              <fmt:message key="adminLocations.intro" />
            </p>
          </div>
          <span class="admin-count"><strong>
              <c:out value="${fn:length(districts)}" />
            </strong>
            <fmt:message key="common.districts" />
          </span>
        </div>
        <c:if test="${not empty error}">
          <p class="alert alert-error" role="alert">
            <c:out value="${error}" />
          </p>
        </c:if>
        <c:if test="${param.updated eq '1'}">
          <p class="alert alert-success" role="status">
            <fmt:message key="adminLocations.updated" />
          </p>
        </c:if>

        <div class="location-admin-grid">
          <section class="admin-panel">
            <div class="admin-panel-heading">
              <div>
                <p class="eyebrow">
                  <fmt:message key="adminLocations.divisionHeading" />
                </p>
                <h2>
                  <fmt:message key="adminLocations.divisionHeading" />
                </h2>
              </div>
            </div>
            <c:choose>
              <c:when test="${not empty editDivisionRecord}">
                <form method="post" action="${pageContext.request.contextPath}/admin/locations" class="admin-form">
                  <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>" /><input type="hidden"
                    name="action" value="updateDivision" /><input type="hidden" name="divisionId"
                    value="${editDivisionRecord.divisionId}" />
                  <label>
                    <fmt:message key="adminLocations.divisionName" /><input name="name" maxlength="50" required
                      value="<c:out value='${editDivisionRecord.name}'/>">
                  </label>
                  <button class="button" type="submit">
                    <fmt:message key="common.save" />
                  </button><a class="table-action" href="${pageContext.request.contextPath}/admin/locations">
                    <fmt:message key="common.cancel" />
                  </a>
                </form>
              </c:when>
              <c:otherwise>
                <form method="post" action="${pageContext.request.contextPath}/admin/locations" class="admin-form">
                  <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>" /><input type="hidden"
                    name="action" value="addDivision" />
                  <label>
                    <fmt:message key="adminLocations.divisionName" /><input name="name" maxlength="50" required>
                  </label>
                  <button class="button" type="submit">
                    <fmt:message key="adminLocations.addDivisionButton" />
                  </button>
                </form>
              </c:otherwise>
            </c:choose>
            <div class="simple-list">
              <c:forEach var="v" items="${divisions}">
                <div><span><strong>
                      <c:out value="${v.name}" />
                    </strong></span><span class="action-buttons">
                    <a class="table-action" href="?editDivision=${v.divisionId}">
                      <fmt:message key="common.edit" />
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/admin/locations"
                      data-confirm="${msgAdminLocationDeleteDivisionConfirm}"><input type="hidden" name="csrfToken"
                        value="<c:out value='${csrfToken}'/>" /><input type="hidden" name="action"
                        value="deleteDivision" /><input type="hidden" name="divisionId"
                        value="${v.divisionId}" /><button class="table-action action-delete" type="submit">
                        <fmt:message key="adminDonors.delete" />
                      </button></form>
                  </span></div>
              </c:forEach>
              <c:if test="${empty divisions}">
                <p class="table-empty">
                  <fmt:message key="adminLocations.emptyDivisions" />
                </p>
              </c:if>
            </div>
          </section>

          <section class="admin-panel">
            <div class="admin-panel-heading">
              <div>
                <p class="eyebrow">
                  <fmt:message key="adminLocations.addDistrict" />
                </p>
                <h2>
                  <fmt:message key="adminLocations.districtDetails" />
                </h2>
              </div>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/locations" class="admin-form">
              <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>" />
              <c:choose>
                <c:when test="${not empty editDistrictRecord}"><input type="hidden" name="action"
                    value="updateDistrict" /><input type="hidden" name="districtId"
                    value="${editDistrictRecord.districtId}" /></c:when>
                <c:otherwise><input type="hidden" name="action" value="addDistrict" /></c:otherwise>
              </c:choose>
              <label>
                <fmt:message key="adminLocations.districtName" /><input name="name" maxlength="80" required
                  value="<c:out value='${editDistrictRecord.name}'/>">
              </label>
              <label>
                <fmt:message key="common.division" /><select name="divisionId" required data-searchable
                  data-search-placeholder="${msgSearchPlaceholder}" data-search-no-results="${msgSearchNoResults}"
                  data-search-required="${msgSearchRequired}">
                  <option value="">
                    <fmt:message key="common.chooseDivision" />
                  </option>
                  <c:forEach var="v" items="${divisions}">
                    <option value="${v.divisionId}" ${editDistrictRecord.divisionId eq v.divisionId ? 'selected' : '' }>
                      <c:out value="${v.name}" />
                    </option>
                  </c:forEach>
                </select>
              </label>
              <button class="button" type="submit">
                <c:choose>
                  <c:when test="${not empty editDistrictRecord}">
                    <fmt:message key="common.save" />
                  </c:when>
                  <c:otherwise>
                    <fmt:message key="adminLocations.addDistrictButton" />
                  </c:otherwise>
                </c:choose>
              </button>
              <c:if test="${not empty editDistrictRecord}"><a class="table-action"
                  href="${pageContext.request.contextPath}/admin/locations">
                  <fmt:message key="common.cancel" />
                </a></c:if>
            </form>
            <div class="simple-list">
              <c:forEach var="d" items="${districts}">
                <div><span><strong>
                      <c:out value="${d.name}" />
                    </strong><small>
                      <c:out value="${d.division}" />
                    </small></span><span class="action-buttons">
                    <a class="table-action" href="?editDistrict=${d.districtId}">
                      <fmt:message key="common.edit" />
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/admin/locations"
                      data-confirm="${msgAdminLocationDeleteDistrictConfirm}"><input type="hidden" name="csrfToken"
                        value="<c:out value='${csrfToken}'/>" /><input type="hidden" name="action"
                        value="deleteDistrict" /><input type="hidden" name="districtId"
                        value="${d.districtId}" /><button class="table-action action-delete" type="submit">
                        <fmt:message key="adminDonors.delete" />
                      </button></form>
                  </span></div>
              </c:forEach>
            </div>
          </section>

          <section class="admin-panel">
            <div class="admin-panel-heading">
              <div>
                <p class="eyebrow">
                  <fmt:message key="adminLocations.addUpazila" />
                </p>
                <h2>
                  <fmt:message key="adminLocations.upazilaDetails" />
                </h2>
              </div>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/locations" class="admin-form">
              <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>" />
              <c:choose>
                <c:when test="${not empty editUpazilaRecord}"><input type="hidden" name="action"
                    value="updateUpazila" /><input type="hidden" name="upazilaId"
                    value="${editUpazilaRecord.upazilaId}" /></c:when>
                <c:otherwise><input type="hidden" name="action" value="addUpazila" /></c:otherwise>
              </c:choose>
              <label>
                <fmt:message key="common.district" /><select name="districtId" required data-searchable
                  data-search-placeholder="${msgSearchPlaceholder}" data-search-no-results="${msgSearchNoResults}"
                  data-search-required="${msgSearchRequired}">
                  <option value="">
                    <fmt:message key="common.chooseDistrict" />
                  </option>
                  <c:forEach var="d" items="${districts}">
                    <option value="${d.districtId}" ${editUpazilaRecord.districtId eq d.districtId ? 'selected' : '' }>
                      <c:out value="${d.name}" />
                    </option>
                  </c:forEach>
                </select>
              </label>
              <label>
                <fmt:message key="adminLocations.upazilaName" /><input name="name" maxlength="100" required
                  value="<c:out value='${editUpazilaRecord.name}'/>">
              </label>
              <button class="button" type="submit">
                <c:choose>
                  <c:when test="${not empty editUpazilaRecord}">
                    <fmt:message key="common.save" />
                  </c:when>
                  <c:otherwise>
                    <fmt:message key="adminLocations.addUpazilaButton" />
                  </c:otherwise>
                </c:choose>
              </button>
              <c:if test="${not empty editUpazilaRecord}"><a class="table-action"
                  href="${pageContext.request.contextPath}/admin/locations">
                  <fmt:message key="common.cancel" />
                </a></c:if>
            </form>
            <div class="simple-list">
              <c:forEach var="a" items="${upazilas}">
                <div><span><strong>
                      <c:out value="${a.name}" />
                    </strong><small>
                      <c:out value="${a.districtName}" />
                    </small></span><span class="action-buttons">
                    <a class="table-action" href="?editUpazila=${a.upazilaId}">
                      <fmt:message key="common.edit" />
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/admin/locations"
                      data-confirm="${msgAdminLocationDeleteUpazilaConfirm}"><input type="hidden" name="csrfToken"
                        value="<c:out value='${csrfToken}'/>" /><input type="hidden" name="action"
                        value="deleteUpazila" /><input type="hidden" name="upazilaId" value="${a.upazilaId}" /><button
                        class="table-action action-delete" type="submit">
                        <fmt:message key="adminDonors.delete" />
                      </button></form>
                  </span></div>
              </c:forEach>
              <c:if test="${empty upazilas}">
                <p class="table-empty">
                  <fmt:message key="adminLocations.emptyUpazilas" />
                </p>
              </c:if>
            </div>
          </section>
        </div>
        <jsp:include page="/admin/includes/footer.jsp" />