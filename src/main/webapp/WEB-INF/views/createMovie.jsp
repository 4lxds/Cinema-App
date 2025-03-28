<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add a Movie</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
    <style>
        input[type="file"]::file-selector-button {
            color: #000;
            background-color: #fff;
            border: 1px solid #ccc;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <h1>Create a New Movie</h1>
    <form action="${pageContext.request.contextPath}/movies/add" method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label for="title" class="form-label">Title:</label>
            <input type="text" id="title" name="title" class="form-control" required/>
        </div>
        <div class="mb-3">
            <label for="description" class="form-label">Description:</label>
            <textarea id="description" name="description" class="form-control"></textarea>
        </div>
        <div class="mb-3">
            <label for="ticketPrice" class="form-label">Ticket Price:</label>
            <input type="number" id="ticketPrice" step="0.01" name="ticketPrice" class="form-control" required/>
        </div>
        <div class="mb-3">
            <label for="movieImage" class="form-label">Movie image:</label>
            <input type="file" id="movieImage" name="imageFile" class="form-control" accept="image/*"/>
        </div>
        <button type="submit" class="btn btn-primary">Create Movie</button>
    </form>
    <br/>
    <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary">Back to Movies List</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>