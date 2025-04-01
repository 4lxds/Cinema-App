<%@ include file="header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Login</title>
    <!-- dark theme-->
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet"/>
    <!-- bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        .card {
            margin-top: 20px;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
        }

        .input-group {
            flex-wrap: nowrap;
        }

        /* merge password input and icon - remove right border and radius */
        #password {
            border-top-right-radius: 0 !important;
            border-bottom-right-radius: 0 !important;
            border-right: none !important;
        }

        /* toggle icon white background no left border */
        .input-group-text {
            background-color: #fff !important;
            border-top-left-radius: 0 !important;
            border-bottom-left-radius: 0 !important;
            border-left: none !important;
            cursor: pointer;
        }

        /* icon size and color */
        #togglePassword i {
            font-size: 20px;
            color: #aaa;
        }
    </style>
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <div class="card bg-secondary text-white">
        <div class="card-header text-center">
            <h2>Login</h2>
        </div>
        <div class="card-body">
            <c:if test="${param.error != null}">
                <div class="alert alert-danger" role="alert">
                    Invalid username or password. Please try again.
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <!-- preserve redirect if exists -->
                <input type="hidden" name="redirect" value="${param.redirect}"/>
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <input type="password" id="password" name="password" class="form-control" required/>
                        <span class="input-group-text" id="togglePassword">
                  <!-- default - slashed eye (password hidden) -->
                  <i id="eyeIcon" class="bi bi-eye-slash"></i>
                </span>
                    </div>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-primary">Login</button>
                </div>
            </form>
            <p class="mt-3 text-center">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register?redirect=${param.redirect}" class="text-info">Register
                    here</a>
            </p>
        </div>
        <div class="card-footer text-center">
            <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary"
               style="border: 1px solid #343a40;">
                Back to Movies List
            </a>
        </div>
    </div>
</div>

<script>
    const togglePassword = document.getElementById('togglePassword');
    const passwordField = document.getElementById('password');
    const eyeIcon = document.getElementById('eyeIcon');

    // password is hidden and slashed eye (bi-eye-slash) is displayed
    let isPasswordVisible = false;
    togglePassword.addEventListener('click', function () {
        isPasswordVisible = !isPasswordVisible;
        // toggle input type
        passwordField.type = isPasswordVisible ? 'text' : 'password';
        // swap icons - when password visible - open eye (bi-eye), else show slashed eye (bi-eye-slash)
        eyeIcon.className = isPasswordVisible ? "bi bi-eye" : "bi bi-eye-slash";
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
