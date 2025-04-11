<%@ include file="header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reserve Tickets for ${movie.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
    <style>
        .seat-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 5px;
            max-width: 500px;
            margin-bottom: 20px;
        }

        .seat-button {
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            border-radius: 4px;
            text-align: center;
            font-size: 0.85rem;
        }

        .seat-available {
            background-color: #28a745;
            color: #000;
            border: 1px solid #008000;
        }

        .seat-reserved {
            background-color: #6c757d;
            color: #fff;
            cursor: not-allowed;
            border: 1px solid #6f7278 !important;
        }

        .seat-selected {
            background-color: #ffa500 !important;
            color: #000 !important;
            border: 1px solid #cc8400 !important;
        }

        .seat-selected:active {
            background-color: #ffa500 !important;
            border: 2px solid #000000 !important;
        }

        .seat-deselected {
            background-color: #28A745FF !important;
            transition: background-color 0.1s ease;
        }

        .dropdown-menu.custom-dropdown {
            width: 40px !important;
            min-width: 40px !important;
            max-width: 40px !important;
            padding: 0 !important;
            background-color: #343a40 !important;
            border: 1px solid #495057 !important;
        }

        .dropdown-item.custom-item {
            font-size: 0.85rem !important;
            padding: 0.25rem 0.4rem !important;
            line-height: 1.2 !important;
            color: #fff !important;
            background-color: transparent;
        }

        .btn-secondary.btn-sm.dropdown-toggle {
            background-color: #545b62 !important;
            border-color: #4e555b !important;
            color: #fff !important;
        }

        .btn-secondary.btn-sm.dropdown-toggle:hover {
            background-color: #545b62 !important;
            border-color: #4e555b !important;
            transform: scale(1.02);
            transition: transform 0.2s ease-in-out, background-color 0.2s ease-in-out, border-color 0.2s ease-in-out;
        }

        /* Legend styling */
        .legend {
            margin-top: 5px;
            text-align: center; /* Center the legend text and items */
        }

        .legend h5 {
            margin-bottom: 5px;
            font-size: 1rem;
        }

        .legend-item {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 5px;
            font-size: 0.9rem;
        }

        .legend-color {
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-right: 8px;
            border-radius: 4px;
            border: 1px solid #000;
        }
    </style>

    <script>
        window.addEventListener("DOMContentLoaded", function () {
            let maxSeats = 0;
            const selectedSeats = new Set();
            const hiddenTicketInput = document.getElementById("numberOfTickets");
            const ticketDropdownButton = document.getElementById("ticketDropdown");
            const hiddenSeatInput = document.getElementById("selectedSeatIds");
            const form = document.getElementById("reservationForm");
            const ticketErrorSpan = document.getElementById("ticketError");

            function showTicketError(message) {
                ticketErrorSpan.textContent = message;
            }

            function clearTicketError() {
                ticketErrorSpan.textContent = "";
            }

            document.querySelectorAll(".ticket-option").forEach(function (item) {
                item.addEventListener("click", function (e) {
                    e.preventDefault();
                    clearTicketError();
                    const value = parseInt(item.getAttribute("data-value"), 10);
                    maxSeats = value;
                    hiddenTicketInput.value = value;
                    ticketDropdownButton.textContent = value;
                    if (selectedSeats.size > maxSeats) {
                        selectedSeats.clear();
                        document.querySelectorAll(".seat-button").forEach(function (btn) {
                            btn.classList.remove("seat-selected");
                        });
                        updateHiddenInput();
                    }
                    updateSeatAvailability();
                });
            });

            function updateHiddenInput() {
                hiddenSeatInput.value = Array.from(selectedSeats).join(",");
            }

            function updateSeatAvailability() {
                const seatButtons = document.querySelectorAll(".seat-button.seat-available");
                seatButtons.forEach((btn) => {
                    const seatId = btn.getAttribute("data-seat-id");
                    if (!selectedSeats.has(seatId) && selectedSeats.size === maxSeats) {
                        btn.style.pointerEvents = "none";
                        btn.style.opacity = "0.8";
                    } else {
                        btn.style.pointerEvents = "auto";
                        btn.style.opacity = "1";
                    }
                });
            }

            document.querySelectorAll(".seat-button").forEach(function (button) {
                if (button.disabled) return;
                button.addEventListener("mousedown", function () {
                    clearTicketError();
                    if (maxSeats === 0) {
                        showTicketError("Please select the number of tickets first.");
                        return;
                    }
                    const seatId = button.getAttribute("data-seat-id");
                    if (selectedSeats.has(seatId)) {
                        button.classList.add("seat-deselected");
                        setTimeout(() => {
                            button.classList.remove("seat-deselected");
                            button.classList.remove("seat-selected");
                            selectedSeats.delete(seatId);
                            updateHiddenInput();
                            updateSeatAvailability();
                        }, 100);
                    } else {
                        if (selectedSeats.size < maxSeats) {
                            selectedSeats.add(seatId);
                            button.classList.add("seat-selected");
                        } else {
                            showTicketError("You can only select " + maxSeats + " seat" + (maxSeats > 1 ? "s." : "."));
                        }
                        updateHiddenInput();
                        updateSeatAvailability();
                    }
                });
            });
            form.addEventListener("submit", function (e) {
                clearTicketError();
                const numberOfTickets = parseInt(hiddenTicketInput.value, 10) || 0;
                const selectedSeatCount = hiddenSeatInput.value.split(",").filter(s => s.trim() !== "").length;
                if (numberOfTickets === 0) {
                    showTicketError("Please select the number of tickets first.");
                    e.preventDefault();
                    return;
                }
                if (selectedSeatCount !== numberOfTickets) {
                    const msg = numberOfTickets === 1 ? "Please select exactly 1 seat." : "Please select exactly " + numberOfTickets + " seats.";
                    showTicketError(msg);
                    e.preventDefault();
                }
            });
        });
    </script>
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <div class="card bg-secondary text-white">
        <div class="card-header text-center">
            <h2 class="mb-0">Reserve Seats for ${movie.title}</h2>
        </div>
        <div class="card-body">
            <div class="row">
                <!-- Left Column: Movie image and legend -->
                <div class="col-md-4 text-center">
                    <c:if test="${not empty base64Image}">
                        <img src="data:image/jpeg;base64,${base64Image}" alt="Movie Image" class="img-fluid mb-3"
                             style="max-width: 300px;"/>
                    </c:if>
                    <c:if test="${empty base64Image}">
                        <span>No Image</span>
                    </c:if>
                    <!-- Legend centered below the image -->
                    <div class="legend">
                        <h5>Legend:</h5>
                        <div class="legend-item">
                            <span class="legend-color"
                                  style="background-color: #28a745; border: 1px solid #008000;"></span>
                            <span>Available Seat</span>
                        </div>
                        <div class="legend-item">
                            <span class="legend-color"
                                  style="background-color: #6c757d; border: 1px solid #6f7278;"></span>
                            <span>Reserved Seat</span>
                        </div>
                        <div class="legend-item">
                            <span class="legend-color"
                                  style="background-color: #ffa500; border: 1px solid #cc8400;"></span>
                            <span>Selected Seat</span>
                        </div>
                    </div>
                </div>
                <!-- Right Column: Reservation form -->
                <div class="col-md-8 text-start">
                    <p class="lead mb-2">Ticket Price: $${movie.ticketPrice}</p>
                    <form id="reservationForm" action="${pageContext.request.contextPath}/reviewReservation"
                          method="post">
                        <input type="hidden" name="movieId" value="${movie.id}"/>
                        <div class="mb-3 d-flex align-items-center">
                            <label class="form-label mb-0 me-2" style="min-width: 120px;">Number of Tickets:</label>
                            <div class="dropdown">
                                <button class="btn btn-secondary btn-sm dropdown-toggle" type="button"
                                        id="ticketDropdown" data-bs-toggle="dropdown" aria-expanded="false"
                                        style="width: 40px;">0
                                </button>
                                <ul class="dropdown-menu custom-dropdown" aria-labelledby="ticketDropdown">
                                    <c:forEach var="i" begin="1" end="10">
                                        <li>
                                            <a class="dropdown-item custom-item ticket-option" href="#"
                                               data-value="${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <input type="hidden" id="numberOfTickets" name="numberOfTickets" value=""/>
                            <span id="ticketError" class="text-danger ms-3"></span>
                        </div>
                        <div class="seat-grid mb-3">
                            <c:forEach var="seat" items="${seats}">
                                <c:choose>
                                    <c:when test="${seat.reservation != null}">
                                        <button type="button" class="seat-button seat-reserved btn btn-secondary"
                                                disabled data-seat-id="${seat.id}">
                                                ${seat.seatLabel}
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="seat-button seat-available btn btn-outline-success"
                                                data-seat-id="${seat.id}">
                                                ${seat.seatLabel}
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <input type="hidden" id="selectedSeatIds" name="selectedSeatIds" value=""/>
                        <button type="submit" class="btn btn-primary">Reserve Selected Seats</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="card-footer text-end">
            <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary"
               style="border: 1px solid #343a40;">Back to Movies List</a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
