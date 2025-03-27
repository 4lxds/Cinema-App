<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Reserve Tickets for ${movie.title}</title>
    <style>
        .seat-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 5px;
            max-width: 500px;
            margin-bottom: 20px;
        }

        .seat-button {
            padding: 10px;
            cursor: pointer;
        }

        .seat-available {
            background-color: #cfc;
        }

        .seat-reserved {
            background-color: #ccc;
            cursor: not-allowed;
        }

        .seat-selected {
            background-color: #4CAF50;
            color: #fff;
        }
    </style>
    <script>
        window.addEventListener("DOMContentLoaded", function () {
            const ticketInput = document.getElementById("numberOfTickets");
            let maxSeats = parseInt(ticketInput.value) || 0;
            const selectedSeats = new Set();
            const hiddenSeatInput = document.getElementById("selectedSeatIds");

            ticketInput.addEventListener("change", function () {
                maxSeats = parseInt(ticketInput.value) || 0;
                if (selectedSeats.size > maxSeats) {
                    selectedSeats.clear();
                    document.querySelectorAll(".seat-button").forEach(function (btn) {
                        btn.classList.remove("seat-selected");
                    });
                    updateHiddenInput();
                }
            });

            function updateHiddenInput() {
                hiddenSeatInput.value = Array.from(selectedSeats).join(",");
            }

            document.querySelectorAll(".seat-button").forEach(function (button) {
                if (button.disabled) return;
                button.addEventListener("click", function () {
                    const seatId = button.getAttribute("data-seat-id");
                    if (selectedSeats.has(seatId)) {
                        selectedSeats.delete(seatId);
                        button.classList.remove("seat-selected");
                    } else {
                        if (selectedSeats.size < maxSeats) {
                            selectedSeats.add(seatId);
                            button.classList.add("seat-selected");
                        } else {
                            alert("You can only select " + maxSeats + " seats.");
                        }
                    }
                    updateHiddenInput();
                });
            });
        });
    </script>
</head>
<body>
<h1>Reserve Seats for ${movie.title}</h1>
<p>Ticket Price: $${movie.ticketPrice}</p>

<form action="${pageContext.request.contextPath}/reserve" method="post">
    <input type="hidden" name="movieId" value="${movie.id}"/>
    <label for="numberOfTickets">Number of Tickets:</label>
    <input type="number" id="numberOfTickets" name="numberOfTickets" min="1" required/><br/><br/>

    <div class="seat-grid">
        <c:forEach var="seat" items="${seats}">
            <c:choose>
                <c:when test="${seat.reservation != null}">
                    <button type="button"
                            class="seat-button seat-reserved"
                            disabled
                            data-seat-id="${seat.id}">
                            ${seat.seatLabel}
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="button"
                            class="seat-button seat-available"
                            data-seat-id="${seat.id}">
                            ${seat.seatLabel}
                    </button>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>


    <input type="hidden" id="selectedSeatIds" name="selectedSeatIds" value=""/>

    <button type="submit">Reserve Selected Seats</button>
</form>

<a href="${pageContext.request.contextPath}/movies">Back to Movies List</a>
</body>
</html>