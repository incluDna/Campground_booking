-- Query แสดงข้อมูลรายการ campground ที่มี user จองมากที่สุด 3 อันดับแรก โดยมีรายละเอียดข้อมูลดังนี้ --
1.	Campground name
2.	Campground telephone
3.	Campground location
4.	Open - time
5.	Close – time
6.	Campground facilities
7.	จำนวนการจองของ campground 


SELECT 
    C.name AS Campground,
    C.location AS Location,
    C.map_url AS Map,
	COALESCE(F.facilities, 'No Facilities') AS Facilities,
    C.open_time AS Open_Time,
    C.close_time AS Close_Time,
    COALESCE(B.booking_made, 0) AS Booking_made
FROM campgrounds C
LEFT JOIN (
    SELECT 
        campground_id, 
        COUNT(*) AS booking_made
    FROM tent_bookings
    GROUP BY campground_id
) B ON C.campground_id = B.campground_id
LEFT JOIN (
    SELECT 
        campground_id, 
        STRING_AGG(DISTINCT facilities, ', ') AS facilities
    FROM campground_facilities
    GROUP BY campground_id
) F ON C.campground_id = F.campground_id
ORDER BY booking_made DESC;
