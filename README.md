# Cinema App

**Cinema App**, as my first fullstack project, is a sleek and effortless ticket booking application that showcases movie details, real-time seat selection, user-based reservations (including admins), and more.

---

## Technologies Used

- **Java 17**
- **Maven**
- **Spring Boot** & **Spring Security**
- **Hibernate**
- **MySQL**
- **JavaScript**
- **HTML & CSS**
- **Bootstrap (Dark Theme)**

---

## Features

- Fully responsive and user-friendly design
- Detailed movie pages with real-time seat selection
- Dark mode design
- Seats are created on movie creation; each seat is stored in the database
- Multiple user roles (including admin-only button and pages for movie creation)
- Automatic admin user creation on site startup if one doesn’t exist
- User-based reservation history
- Encoded (hashed) passwords for users in database
- JavaScript logic used for seat selection error handling
- Admin only Button and Movie Creation Page:
  
![Admin Button](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/10.admin%20only%20button.png)
![Admin page](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/11.create%20a%20new%20movie%20page.png)

---

## Usage

### Walkthrough

Here are the steps for booking a movie ticket:

1. **Movie Selection:**  
   ![Movies List](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/1.movies%20list.png) 
   Check which movie you’d like to book tickets for on the **Movies List** page.
   
2. **Movie Details:**  
   ![Movie Details](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/5.movie%20details.png)
   You can check the description of each movie by clicking on it and go further by clicking **Reserve Seats**.

3. **Authentication:**
   ![Login page](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/2.login%20page.png)
   ![Register page](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/3.register%20page.png)
   Login or Register to be able to book tickets.

5. **Seat Selection:**
   ![Seat Selection](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/6.seat%20selection.png)
   Select how many tickets you’d like and afterwards the seats themselves.

6. **Reservation Summary:**
   ![Reservation Summary](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/7.reservation%20summary.png)
   ![Thank You page](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/8.reservation%20confirmation.png)
   Review your reservation summary and click **Confirm Reservation**. Then, view the **Thank You** page.

7. **Reservations List**
   ![Account Dropdown](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/4.account%20managment%20dropdown.png)
   ![My Reserevations](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/9.my%20reservations.png)
   At this point, you can check your reservation by clicking on your account.

---

### Error Cases

In case of errors, the application provides clear messages:

1. **Not Logged In:**
   ![Not Logged In](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/errors/1.not%20logged%20in.png)
   Error message for not being logged in when trying to reserve tickets.
   
3. **No Ticket Selection:**
   ![No Ticket Selection](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/errors/2.no%20seats%20selected.png)
   Error for not selecting a number of tickets.

4. **Insufficient Seat Selection:**
   ![Insufficient Seat Selection](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/errors/3.less%20seats%20selected.png)
   Error if the number of seats selected does not match the number of tickets chosen.

5. **Username/Password Invalid:**
   ![Username/Password Invalid](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/errors/4.invalid%20username%20or%20password.png)
   Error handling for an invalid username or password.

6. **Username Taken:**
   ![Username Taken](https://github.com/4lxds/Cinema-App/blob/main/cinema%20app%20photos/errors/5.username%20already%20exists.png)
   Error handling if the username is taken when creating a new account.

---

## Post-project Reflection Notes & Insights. Things I overcame.

Several challenges i faced along the way:
- _Form Handling for Logout vs. Seat Reservation on the Seat Reservation page:_
  The “Logout” button initially interfered with the seat reservation form submission. I solved this by creating two separate forms.
  
- _Image Handling:_  
  I found it hard to implement and store images in the database. I used a Data Transfer Object (DTO) pattern for handling images in the end.

- _Secure Reservation Access:_  
  On the "Thank You" page, the reservation ID could be manipulated to view other reservations. To solve this, I changed it so that the storing of the reservation was made in a session which validates the reservation ID, then redirects users to the Movies List if it doesn’t match.

- _Reservation Workflow:_  
  The reservations were being saved when clicking “Reserve selected seats”, not when clicking  “Confirm Reservation” on the “Reservation Summary” page. Now, it gets stored in a temporary reservation and then finalized only when “Confirm Reservation” is clicked.

- _Spring Security:_  
  Configuring Spring Security was difficult, as it was blocking access to all JSPs and the logo image used. I solved this by customizing the WebSecurity settings to ignore the JSP and the images folder.

- _Hibernate Naming Scheme:_  
  I had to disable the default Hibernate naming strategy for MySQL because it was causing issues and to better suit my schema.
---
