<%@ include file="header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet"/>
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

        #password {
            border-top-right-radius: 0 !important;
            border-bottom-right-radius: 0 !important;
            border-right: none !important;
        }

        .input-group-text {
            background-color: #fff !important;
            border-top-left-radius: 0 !important;
            border-bottom-left-radius: 0 !important;
            border-left: none !important;
            cursor: pointer;
        }

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
            <h2>Register</h2>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">${error}</div>
            </c:if>
            <form action="<c:url value='/register?redirect=${redirect}'/>" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <input type="password" id="password" name="password" class="form-control" required/>
                        <span class="input-group-text" id="togglePassword">
                <i id="eyeIcon" class="bi bi-eye-slash"></i>
              </span>
                    </div>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-primary">Register</button>
                </div>
            </form>
            <p class="mt-3 text-center">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login?redirect=${redirect}" class="text-info">Login here</a>
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
    //toggle password visibility
    const togglePassword = document.getElementById('togglePassword');
    const passwordField = document.getElementById('password');
    const eyeIcon = document.getElementById('eyeIcon');

    //default password hidden (bi-eye-slash)
    let isPasswordVisible = false;

    togglePassword.addEventListener('click', function () {
        isPasswordVisible = !isPasswordVisible;
        //toggle input type between password and text
        passwordField.type = isPasswordVisible ? 'text' : 'password';
        //swap the icon: when password visible (bi-eye); hidden (bi-eye-slash)
        eyeIcon.className = isPasswordVisible ? "bi bi-eye" : "bi bi-eye-slash";
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
