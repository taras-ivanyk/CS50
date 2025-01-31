-- ALSO I WERE CHECKING [ .schema / .tables ] but i wasn't write this in my commentaries, because this takes a lot of time



-- *************** 1) Firstly, i want to find more details about the crime, i think that i can find this in crime-scene-reports description:   *************************

    SELECT description FROM crime_scene_reports WHERE day = 28 AND month = 7 AND street = 'Humphrey Street';

-- Here i see that THEFT TOOK PLACE AT 10:15 AM AT 28 OF JULY AT THE HUMPHREY STREET BAKERY, THREE WITNESSES EACH OF THEIR INTERVIEW TRANSCRIPTS MENTIONS THE BAKERY.

-- *************** 2) Secondly, i write: ********************

    SELECT transcript FROM interviews WHERE day = 28 AND month = 7;

-- To see what people that give interview said about the thief, here it is:

-- 1. Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars
-- that left the parking lot in that time frame.

-- 2. As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville
-- tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.

-- 3. I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.

--******************* 3) Then (FROM 1 INTERVIEW) i write this to see the possible license_plate of thief car: (Firstly, i will check car that will be first in my list, then next): *********************

    SELECT license_plate FROM bakery_security_logs WHERE month = 7 AND day = 28 AND hour = 10 AND minute >= 15 AND minute <= 20;

-- AND I SEE THESE POSSIBLE LICENSE PLATES OF THIEF CAR:
-- +---------------+
-- | license_plate |
-- +---------------+
-- | 5P2BI95       |
-- | 94KL13X       |
-- | 6P58WS2       |
-- | 4328GD8       |
-- | G412CB7       |
-- +---------------+

--********************** 4) Then (FROM 2 INTERVIEW) i write these to see phone_calls that continuing LESS THAN A MINUTE and maybe have some words that thief potentially can say (TAKE THE EARLIEST FLIGHT OUT OF FIFTYVILLE
-- TOMORROW.) *************************

    SELECT caller, receiver FROM phone_calls WHERE duration < 60 AND duration > 30 AND day = 28 AND month = 7;  -- AND I SEE THESE NUMBERS:

-- +----------------+----------------+
-- |     caller     |    receiver    |
-- +----------------+----------------+
-- | (130) 555-0289 | (996) 555-8899 |
-- | (499) 555-9472 | (892) 555-8872 |
-- | (367) 555-5533 | (375) 555-8161 |
-- | (499) 555-9472 | (717) 555-1342 |
-- | (286) 555-6063 | (676) 555-6554 |
-- | (770) 555-1861 | (725) 555-3243 |
-- | (031) 555-6622 | (910) 555-3251 |
-- | (826) 555-1652 | (066) 555-9701 |
-- | (338) 555-6650 | (704) 555-2131 |
-- +----------------+----------------+

--******************* 5) Then (FROM 3 INTERVIEW) i know that thief was withdrawing some money at the Leggett Street, so i write this query to see some transactions in the bank, maybe i'll find the same phone number, that i find in 4) *********************

    SELECT account_number FROM atm_transactions WHERE day = 28 AND month = 7 AND year = 2023 AND atm_location = 'Leggett Street';

-- +----------------+
-- | account_number |
-- +----------------+
-- | 28500762       |
-- | 28296815       |
-- | 76054385       |
-- | 49610011       |
-- | 16153065       |
-- | 86363979       |
-- | 25506511       |
-- | 81061156       |
-- | 26013199       |
-- +----------------+
-- I find account numbers, not telephone number, so next i must to check another table - bank_accounts:

    SELECT person_id FROM bank_accounts WHERE account_number IN
        (SELECT account_number FROM atm_transactions WHERE day = 28 AND month = 7 AND year = 2023 AND atm_location = 'Leggett Street');

-- then i find people_id of these numbers:
-- +-----------+
-- | person_id |
-- +-----------+
-- | 686048    |
-- | 948985    |
-- | 514354    |
-- | 458378    |
-- | 395717    |
-- | 396669    |
-- | 467400    |
-- | 449774    |
-- | 438727    |
-- +-----------+
-- IN people table i also find license_plate, so know i'll try to write all the information i have and find the thief:

    SELECT name, passport_number FROM people WHERE id IN
        (SELECT person_id FROM bank_accounts WHERE account_number IN
            (SELECT account_number FROM atm_transactions WHERE day = 28 AND month = 7 AND year = 2023 AND atm_location = 'Leggett Street')) AND license_plate IN
        (SELECT license_plate FROM bakery_security_logs WHERE month = 7 AND day = 28 AND hour = 10 AND minute >= 15 AND minute <= 20);

--AND so, i see 2 people:
-- +-------+-----------------+
-- | name  | passport_number |
-- +-------+-----------------+
-- | Luca  | 8496433585      |
-- | Bruce | 5773159633      |
-- +-------+-----------------+
-- Someone from them is thief, who it can be?
-- Now i'll try to see some information about the flights:

sqlite> .schema flights
-- CREATE TABLE flights (
--     id INTEGER,
--     origin_airport_id INTEGER,
--     destination_airport_id INTEGER,
--     year INTEGER,
--     month INTEGER,
--     day INTEGER,
--     hour INTEGER,
--     minute INTEGER,
--     PRIMARY KEY(id),
--     FOREIGN KEY(origin_airport_id) REFERENCES airports(id),
--     FOREIGN KEY(destination_airport_id) REFERENCES airports(id)
-- );

--I know that that the thief takes the earliest flight out of Fiftyville tomorrow, so i'll check origin_airport_id that is FIFTYVILLE:

    SELECT * FROM airports WHERE city = 'Fiftyville';

-- +----+--------------+-----------------------------+------------+
-- | id | abbreviation |          full_name          |    city    |
-- +----+--------------+-----------------------------+------------+
-- | 8  | CSF          | Fiftyville Regional Airport | Fiftyville |
-- +----+--------------+-----------------------------+------------+

-- So, know i want to see more information about the flights that have origin_airport_id (8) AND flight away at 29 of JULY:

    SELECT * FROM flights WHERE origin_airport_id = 8 AND month = 7 AND day = 29;

-- +----+-------------------+------------------------+------+-------+-----+------+--------+
-- | id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
-- +----+-------------------+------------------------+------+-------+-----+------+--------+
-- | 18 | 8                 | 6                      | 2023 | 7     | 29  | 16   | 0      |
-- | 23 | 8                 | 11                     | 2023 | 7     | 29  | 12   | 15     |
-- | 36 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     |
-- | 43 | 8                 | 1                      | 2023 | 7     | 29  | 9    | 30     |
-- | 53 | 8                 | 9                      | 2023 | 7     | 29  | 15   | 20     |
-- +----+-------------------+------------------------+------+-------+-----+------+--------+

-- Also i know that the thief takes the earliest flight, so here it is:

-- +----+-------------------+------------------------+------+-------+-----+------+--------+
-- | id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
-- +----+-------------------+------------------------+------+-------+-----+------+--------+
-- | 36 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     |
-- +----+-------------------+------------------------+------+-------+-----+------+--------+

-- Now, i'll see more information about the passengers of this flight:

    SELECT * FROM passengers WHERE flight_id = 36 AND passport_number = 8496433585 OR passport_number = 5773159633;

-- +-----------+-----------------+------+
-- | flight_id | passport_number | seat |
-- +-----------+-----------------+------+
-- | 36        | 5773159633      | 4A   |
-- | 36        | 8496433585      | 7B   |
-- +-----------+-----------------+------+

-- So, unfortunately for me, i see that two suspects take same flight, i'll find some information about the destination airport:

    SELECT * FROM airports WHERE id = 4;

-- +----+--------------+-------------------+---------------+
-- | id | abbreviation |     full_name     |     city      |
-- +----+--------------+-------------------+---------------+
-- | 4  | LGA          | LaGuardia Airport | New York City |
-- +----+--------------+-------------------+---------------+

-- I forgot, that i don't check thief's number:

    SELECT name, phone_number FROM people WHERE name = 'Luca' OR name = 'Bruce' AND passport_number = 8496433585 OR passport_number = 5773159633;

-- +-------+----------------+
-- | name  |  phone_number  |
-- +-------+----------------+
-- | Luca  | (389) 555-5198 |
-- | Bruce | (367) 555-5533 |
-- +-------+----------------+

    SELECT * FROM phone_calls WHERE caller = '(389) 555-5198' OR caller = '(367) 555-5533' AND day = 28 AND month = 7 AND duration < 60;

-- +-----+----------------+----------------+------+-------+-----+----------+
-- | id  |     caller     |    receiver    | year | month | day | duration |
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | 233 | (367) 555-5533 | (375) 555-8161 | 2023 | 7     | 28  | 45       |
-- +-----+----------------+----------------+------+-------+-----+----------+

-- Also i need to find accomplice:
-- I'll find by his number (375) 555-8161:

    SELECT name FROM people WHERE phone_number = '(375) 555-8161';

-- So the name is ROBIN

-- So, the thief has number (367) 555-5533, SO BRUCE - IS THE THIEF!!!!
-- City that he escaped to is NEW YORK
-- Accomplise is Robin
