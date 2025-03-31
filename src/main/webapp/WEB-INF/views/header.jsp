<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<div id="logoutContainer">
    <form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="post" style="display:none;">
        <input type="hidden" name="redirect" value="${externalUrl}"/>
    </form>
    <a href="#" onclick="document.getElementById('logoutForm').submit(); return false;"
       style="display:none;">Logout</a>
</div>


<c:set var="externalUrl" value="${externalUrl != null ? externalUrl : pageContext.request.requestURL.toString()}"/>

<c:set var="internalPrefix" value="${pageContext.request.contextPath}/WEB-INF"/>

<c:if test="${fn:startsWith(externalUrl, internalPrefix)}">
    <c:set var="externalUrl" value="${pageContext.request.contextPath}/movies"/>
</c:if>

<c:if test="${fn:indexOf(externalUrl, '/movies') == -1 and fn:indexOf(externalUrl, '/movie/') == -1}">
    <c:set var="externalUrl" value="${pageContext.request.contextPath}/movies"/>
</c:if>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/movies">Cinema Reservation</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarContent" aria-controls="navbarContent"
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav ms-auto">
                <sec:authorize access="!isAuthenticated()">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login?redirect=${externalUrl}">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a>
                    </li>
                </sec:authorize>

                <sec:authorize access="isAuthenticated()">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <sec:authentication property="principal.username"/>
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="userDropdown">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/myReservations">
                                    My Reservations
                                </a>
                            </li>
                            <li>
                                <hr class="dropdown-divider"/>
                            </li>
                            <li>
                                <form action="${pageContext.request.contextPath}/logout" method="post"
                                      style="margin: 0;">
                                    <input type="hidden" name="redirect" value="${externalUrl}"/>
                                    <button type="submit" class="dropdown-item" formnovalidate
                                            onclick="event.stopPropagation();">Logout
                                    </button>
                                </form>
                            </li>
                        </ul>
                    </li>
                </sec:authorize>
            </ul>
        </div>
    </div>
</nav>
