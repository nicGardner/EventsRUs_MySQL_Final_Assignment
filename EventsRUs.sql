# 1
create schema EventsRUsHR;
create schema EventsRUsServices;
create schema EventsRUsBookings;

# 2
#######################################################################################################################################
/*
	EventsRUsHR schema hold info on employees and rolls within the company
    
    tables:
		employees
        rolls
        departments
*/
use EventsRUsHR;
#######################################################################################################################################

/*
	a list of all positions within the company that employees of Events R Us occupy
    
    has a many to one relationship with employees
    
    I designed this table to be a list of all the different rolls within the company, and nothing else, that way rolls
    can be easily added, removed, or modified as needed.
    
    this satisfies the client's need for a catalog of employee roles 
*/
create table rolls 
(
	id int primary key auto_increment, 
    rollName varchar(100), 
    rollDesc varchar(1000)
);

/*
	a list of all departments that employees of Events R Us work insert
    
    has a many to one relationship with employees
    
    Much like the rolls table, I designed this table to be a simple list of all the different departments within 
    the company, that way departments can be easily added, removed, or modified as needed.
    
    this satisfies the client's need for a catalog of employee departments 
*/
create table departments
(
	id int primary key auto_increment, 
    deptName varchar(100),
    deptDesc varchar(1000)
);

/*
	a list of all employees working for Events R Us
    
    has a one to many relationship with the following tables: 
        rolls
        departments
        
	has a many to one relationshp with EventsRUsBookings.employeeSchedule
    
    I designed this table to draw information from the rolls and departments table to ensure consistency in the 
    names of departments and rolls. 
    
    this satisfies the client's need for a catalog of employee/staff data
*/
create table employees 
(
	id int primary key auto_increment, 
    fName varchar(20), 
    lName varchar(20), 
    rollId int, 
    departmentId int, 
    hourlyWage double(4,2), 
    foreign key fk_rollId(rollId) references rolls(id),
    foreign key fk_departmentId(departmentId) references departments(id)
);





#######################################################################################################################################
/*
	EventsRUsServices schema holds info on the services provided
    
    tables:
		approvedVenues
        locationPolicies
        eventTypes
        eventPolicies
        services
        
*/
use EventsRUsServices;
#######################################################################################################################################



/*
	a list of the policies associated with the approved venues
    
    has a one to many relationship with approvedVenues
    
    I designed this table, much like the rolls and descriptions tables, to be a simple list of all the unique 
    location policies that the company has on file, so they can be easily updated if need be. 
    
    this (along with eventPolicies) satisfies the client's need for a A catalog of Policies & Regulations Event-R-Us adheres to
*/
create table locationPolicies
(
	id int primary key auto_increment, 
    policyName varchar(100),
    policyDesc varchar(1000)
);

/*
	a list of all venues Events R Us will book events at
    
    has a many to one relationship with locationPolicies
    
    I designed this table to, when drawing from the locationPolicies table, be a complete list of all the 
    approved venues, and all the relavent information on them
    
    this satisfies the client's need for a catalog of Locations Event-R-Us currently serves
*/
create table approvedVenues
(
	id int primary key auto_increment, 
    venueName varchar(100), 
    address varchar(100),
    venueDesc varchar(1000),
    phone varchar(12),
    website varchar(200), 
    email varchar(100),
    price double(7,2), 
    locationPolicyId int, 
    foreign key fk_locationPolicyId(locationPolicyId) references locationPolicies(id)
);

/*
	a list of the policies associated with different types of events Events R Us runs
    
    has a one to one relationship with eventTypes
    
    I designed this list to be kept seperate from the eventTypes list, even though they line up with a 
    1 to 1 relationship because I feel it is better oranized this way, since in most queries involving event types, 
    a user will likely not be looking for the event policies. 
    
    this (along with locationPolicies) satisfies the client's need for a A catalog of Policies & Regulations Event-R-Us adheres to
*/
create table eventPolicies
(
	id int primary key auto_increment, 
    policyName varchar(100),
    policyDesc varchar(1000)
);

/*
	a list of the types of events Events R Us hosts (birthdays, weddings, etc)
    
    has a one to one relationship with eventPolicies
    
    I designed this table to be a simple list of all the event types that Events R Us currently offers. 
    
    this satisfies the client's need for a catalog of events data
*/
create table eventTypes
(
	id int primary key auto_increment, 
    eventPolicyId int unique, 
    eventName varchar(100), 
    eventTypeDesc varchar(1000), 
    foreign key fk_eventPolicy(eventPolicyId) references eventPolicies(id)
);

/*
	a list of all services that Events R Us provides
    
    has a one to many relationship with EventsRUsBookings.serviceSchedule
    
    I designed this table to be a simple list of all the services that are offered by Events R Us
    
    this satisfies the client's need for a catalog of services Event-R-Us has available for its cliental.
*/
create table services
(
	id int primary key auto_increment, 
    serviceName varchar(100), 
    description varchar(1000),
    price double(6, 2)
);





#######################################################################################################################################
/*
	EventsRUsBookings schema holds info on all the current bookings
    
    tables: 
		clients
		bookedEvents
        employeeSchedule
        serviceSchedule
*/
use EventsRUsBookings;
#######################################################################################################################################

/*
	a list of all clients Events R Us has booked events for
    
    has a one to many relationship with bookedEvents
    
    This table is a simple list of all the clients that have hired Events R Us, and all the relevant information on them.

	this satisfies the client's need for a catalog of client data
*/
create table clients
(
	id int primary key auto_increment, 
    fName varchar(20),
    lName varchar(20),
    phone varchar(12), 
    email varchar(100)
);

/*
	a list of all booked events with foreign keys to all the tables needed to get the details 
    such as the address, type of event, etc.
    
	the primary key is a composite of id and venueId to avoid double booking of venues
    
    has a many to one relationship with the following tables: 
		clients
		EventsRUsServices.approvedVenues
        EventsRUsServices.eventTypes
        
	has a one to many relationship with the following tables: 
		employeeSchedule
        servicesSchedule
        
	I designed this table to be the 'hub' of sorts where all the relevant info on a booked event 
    comes together. It draws from 3 other tables to get the client info, as well as a list per event of 
    all the employees and services booked, which would not be possible in a single table.
    
    this satisfies the client's need for a few things: 
		a catalog of venues Event-R-Us has available for booking (since the table will not allow a venue to be booked more than once at the same time)
        A catalog of all events booked with Events-R-Us
*/
create table bookedEvents
(
	id int auto_increment, 
    clientId int,
    venueId int, 
    eventTypeId int, 
    eventName varchar(100), 
    eventDate datetime,
    primary key (id, venueId),
    foreign key fk_clientId(clientId) references clients(id),
    foreign key fk_venueId(venueId) references EventsRUsServices.approvedVenues(id), 
    foreign key fk_eventTypeId(eventTypeId) references EventsRUsServices.eventTypes(id)
);

/*
	a list of all the employees booked for various events
    
    the primary key is a composite of employeeId and eventId to avoid double booking employees
    
    has a many to one relationship with he following tables: 
		EventsRUsHR.employees
        bookedEvents
        
	I designed this table as a list of all employee bookings at all booked events, 
    so a querey could give a list of employees working a given event.
    
    this table satisfies the client's need for a catalog of services Event-R-Us clients are using for a particular event
*/
create table employeeSchedule
(
	employeeId int, 
	eventId int, 
    primary key (employeeId, eventId), 
    foreign key fk_employeeId(employeeId) references EventsRUsHR.employees(id),
    foreign key fk_eventId(eventId) references bookedEvents(id)
);

/*
	a list of all the services booked for various events
    
    the primary key is a composite of serviceId and eventId to avoid double booking employees
    
    has a many to one relationship with the following tables:
		EventsRUsServices.services
        bookedEvents
        
	I designed this table as a list of all services bookings at all booked events, 
    so a querey could give a list of services scheduled for a given event.
*/
create table serviceSchedule
(
	serviceId int, 
	eventId int, 
    primary key (serviceId, eventId), 
    foreign key fk_serviceId(serviceId) references EventsRUsServices.services(id),
    foreign key fk_serviceSchedule_eventId(eventId) references bookedEvents(id)
);





# 3
#######################################################################################################################################
use EventsRUsHR;

insert into rolls (rollName, rollDesc) values
('Janitor', 'a person employed as a caretaker of a building; a custodian.'), 
('Chef', 'a professional cook, in charge of other kitchen staff'), 
('Line Cook', 'a cook working under the Chef'), 
('Dish Washer', 'a person employed to wash dishes'), 
('Waiter', 'a person who serves customers'), 
('Musician', 'a person who plays a musical instrument professionally');

insert into departments (deptName, deptDesc) values
('Sanitation', 'the department responsible for cleaning up before and after events'), 
('catering', 'the department responsible for all catering services'), 
('entertainment', 'the department responsible for providing live entertainment services'), 
('accounting', 'the department responsible for ensuring the company\'s finances are in order'), 
('Human Resources', 'the department responsible for the management of employees'), 
('Purchasing', 'the department responsible for orderin products the company needs');

insert into employees (fName, lName, rollId, departmentId, hourlyWage) values 
('Nico', 'Huang', 1, 1, 15.00), 
('Gurdeep', 'George', 2, 2, 50.00), 
('Jannah', 'Bray', 3, 2, 17.30),
('Terence', 'Bannister', 4, 2, 15.00),
('Alanis', 'Rice', 5, 2, 15.00),
('Guto', 'Conrad', 6, 3, 27.85);

use EventsRUsServices;

insert into services (serviceName, price, description) values
('cleanup', 200.00, 'book our janitorial staff to clean up after the event'),
('catering', 1000.00, 'book our kitchen staff to prepare meals for the guests'),
('live music', 150.00, ' book one or more of our musicians to play at the event'), 
('Styling', 350.00, 'work with the client to ensure the venue is decorated to their liking'), 
('Budget Development', 150.00, 'help the customer plan out the budget for their event');

insert into locationPolicies (policyName, policyDesc) values
('church policies', 'placeholder description'),
('banquet hall policies', 'placeholder description'),
('convention center policies', 'placeholder description');

insert into eventPolicies (policyName, policyDesc) values
('birthday', 'placeholder description'),
('wedding', 'placeholder description'),
('trade show', 'placeholder description'),
('executive retreat', 'placeholder description'),
('convention', 'placeholder description');

insert into eventTypes (eventName, eventPolicyId, eventTypeDesc) values
('Birthday', 1, 'Birthday parties'),
('wedding', 2, 'Weddings'),
('Trade Show', 3, 'Trade Shows, for various industries'),
('Execute Retreat', 4, 'corporate event away from the office'),
('convention', 5, 'large meeting of people to share thier interest in a specific topic');

insert into approvedVenues (venueName, price, locationPolicyId, address, venueDesc, phone, website, email) values
('church 1', 1000.00, 1, '123 Street St.', 'a place of worship, rents out space on weekdays', '123-456-7890', 'www.not-a-real-website.com', '123@abc.com'),
('church 2', 750.00, 1, '123 Street St.', 'another place of worship, rents out space on weekdays', '123-456-7890', 'www.not-a-real-website.com', '123@abc.com'),
('banquet hall 1', 3500.00, 2, '123 Street St.', 'a banquet hall', '123-456-7890', 'www.not-a-real-website.com', '123@abc.com'),
('banquet hall 2', 2000.00, 2, '123 Street St.', 'another banquet hall', '123-456-7890', 'www.not-a-real-website.com', '123@abc.com'),
('convention center 1', 50000.00, 3, '123 Street St.', 'a convention center', '123-456-7890', 'www.not-a-real-website.com', '123@abc.com'),
('convention center 2', 75000.00, 3, '123 Street St.', 'another convention center', '123-456-7890', 'www.not-a-real-website.com', '123@abc.com');

use EventsRUsBookings;

insert into clients (fName, lName, phone, email) values
('Suzanne', 'Thompson', '1234567890', '123@abc.com'),
('Colm', 'Moody', '1234567890', '123@abc.com'),
('Melanie', 'Davidson', '1234567890', '123@abc.com'),
('Maizie', 'Craig', '1234567890', '123@abc.com'), 
('Angelo', 'Lyon', '1234567890', '123@abc.com'),
('Izzie', 'Franks', '1234567890', '123@abc.com');

insert into bookedEvents (eventName, clientId, venueId, eventTypeId, eventDate) values
( 'birthday 1', 1, 1, 1, '2018-12-15 00:00:00'),
( 'wedding 1', 1, 1, 2, '2019-01-10 06:00:00'),
( 'trade show 1', 2, 2, 3, '2019-03-15 14:00:00'),
( 'trade show 2', 2, 2, 3, '2019-03-16 16:00:00'),
( 'wedding 2', 3, 3, 2, '2019-10-22 09:00:00'),
( 'birthday 2', 3, 3, 1, '2019-12-15 07:00:00');

insert into employeeSchedule (employeeId, eventId) values
( 1, 1),
( 2, 1),
( 1, 2),
( 3, 2),
( 4, 3),
( 6, 3),
( 4, 4),
( 1, 4),
( 1, 5),
( 6, 5),
( 2, 6),
( 3, 6);

insert into serviceSchedule (serviceId, eventId) values
( 1, 1),
( 2, 1),
( 1, 2),
( 3, 2),
( 2, 3),
( 3, 3),
( 1, 4),
( 2, 4),
( 2, 5),
( 3, 5),
( 1, 6),
( 3, 6);





# 4
#######################################################################################################################################

# 4.1 Display event name, location, venue and price for all events booked with Events-R-Us, sorted by event data ascending
select EventsRUsBookings.bookedEvents.eventName as `event Name`, 
eventsRUsServices.approvedVenues.address as `location`, 
EventsRUsServices.approvedVenues.venueName as `venue`, 
(sum(eventsRUsServices.services.price) + eventsRUsServices.approvedVenues.price) as `total price`, 
EventsRUsBookings.bookedEvents.eventDate as `date`
from eventsRUsServices.services 
left join EventsRUsBookings.serviceSchedule on eventsRUsServices.services.id = EventsRUsBookings.serviceSchedule.serviceId
left join EventsRUsBookings.bookedEvents on EventsRUsBookings.serviceSchedule.eventId = EventsRUsBookings.bookedEvents.id
left join eventsRUsServices.approvedVenues on EventsRUsBookings.bookedEvents.venueId = eventsRUsServices.approvedVenues.id
group by EventsRUsBookings.serviceSchedule.eventId
order by EventsRUsBookings.bookedEvents.eventDate asc;

# 4.2 Display all staff information (personal data, department info, employee role) 
# that has been hired as a service add-on for all Event-R-Us events, sorted by last name then first name 
use EventsRUsHR;
select employees.fName, employees.lName, departments.deptName, departments.deptDesc, rolls.rollName, rolls.rollDesc
from EventsRUsBookings.employeeSchedule
left join employees on EventsRUsBookings.employeeSchedule.employeeId = employees.id
left join departments on employees.departmentId = departments.id
left join rolls on employees.rollId = rolls.id
order by employees.lName, employees.fName;

#4.3 The average price (including add-ons) for all booked events per unique event type sorted by highest average value. 
# ▪ E.G., The average wedding price is : $10000, birthday: $750 
use EventsRUsBookings;
select EventsRUsServices.eventTypes.eventName as `event type`,
(sum(EventsRUsServices.services.price) + EventsRUsServices.approvedVenues.price)/count(serviceSchedule.eventId) as `avg`
from EventsRUsServices.services 
left join serviceSchedule on EventsRUsServices.services.id = serviceSchedule.serviceId
left join bookedEvents on serviceSchedule.eventId = bookedEvents.id
left join EventsRUsServices.approvedVenues on bookedEvents.venueId = EventsRUsServices.approvedVenues.id
left join EventsRUsServices.eventTypes on bookedEvents.eventTypeId = EventsRUsServices.eventTypes.id
group by EventsRUsServices.eventTypes.eventName
order by bookedEvents.eventDate asc;





# 5
#######################################################################################################################################

/*
	Roll: Admin
    permissions: 
		All permissions on all 3 schemas
*/

create user if not exists 
	'Admin1'@'localhost' identified by 'password';
    
GRANT 
ALL
ON eventsrushr.*
TO 'Admin1'@'localhost';
FLUSH PRIVILEGES;

GRANT 
ALL
ON eventsrusservices.*
TO 'Admin1'@'localhost';
FLUSH PRIVILEGES;

GRANT 
ALL
ON eventsrusbookings.*
TO 'Admin1'@'localhost';
FLUSH PRIVILEGES;

/*
	Roll: HR user
    Permissions:
		All data manipulation permissions on EventsRUsHr
*/

create user if not exists 
	'HR1'@'localhost' identified by 'password';

GRANT 
DELETE, INSERT, SELECT, UPDATE
ON eventsrushr.* 
TO 'HR1'@'localhost';
FLUSH PRIVILEGES;

/*
	Roll: Event Master
    Permissions:
		All data manipulation permissions on EventsRUsBookings
        View only permissions on the other two tables
*/

create user if not exists 
	'EventMaster1'@'localhost' identified by 'password';
    
GRANT 
DELETE, INSERT, SELECT, UPDATE
ON eventsrusbookings.* 
TO 'EventMaster1'@'localhost';
FLUSH PRIVILEGES;

GRANT 
SELECT
ON eventsrushr.* 
TO 'EventMaster1'@'localhost';
FLUSH PRIVILEGES;

GRANT 
SELECT
ON eventsrusservices.* 
TO 'EventMaster1'@'localhost';
FLUSH PRIVILEGES;

/*
	Roll: Agent
    Permissions:
        View only permissions on all three tables
*/

create user if not exists 
	'Agent1'@'localhost' identified by 'password';

GRANT 
SELECT
ON eventsrushr.* 
TO 'Agent1'@'localhost';
FLUSH PRIVILEGES;

GRANT 
SELECT
ON eventsrusbookings.* 
TO 'Agent1'@'localhost';
FLUSH PRIVILEGES;

GRANT 
SELECT
ON eventsrusservices.* 
TO 'Agent1'@'localhost';
FLUSH PRIVILEGES;








