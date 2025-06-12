SELECT * FROM (
        SELECT 
        CASE -- This column is the same as the very first column but obtaining timestamp instead of the ROWID value. A CASE statement is used to capture data whether using seconds since Jan 1, 1970 or microseconds since Jan 1, 1970
            WHEN length(DATE) = 18 
            THEN LAG(DATETIME(DATE/1000000000 + 978307200, 'UNIXEPOCH'),1) OVER (ORDER BY ROWID) 
            WHEN length(DATE) = 9
            THEN LAG(DATETIME(DATE + 978307200, 'UNIXEPOCH'),1) OVER (ORDER BY ROWID)
            END AS "Beginning Timestamp",
        CASE -- Finally, this last column obtains the timestamp for the row following the missing row
            WHEN length(DATE) = 18 
            THEN DATETIME(DATE/1000000000 + 978307200, 'UNIXEPOCH') 
            WHEN length(DATE) = 9
            THEN DATETIME(DATE + 978307200, 'UNIXEPOCH')
            END  AS "Ending Timestamp",
		LAG (ROWID,1) OVER (ORDER BY ROWID) AS "Previous ROWID", -- This column uses the LAG function to obtain the ROWID value prior to a missing row
        ROWID AS "ROWID", -- This column obtains the ROWID value following the missing row
        (ROWID - (LAG (ROWID,1) OVER (ORDER BY ROWID)) - 1) AS "Number of Missing Rows" -- This column is a subtraction of the first two columns, minus one additional value, to obtain the number of missing rows
        FROM message) list
        WHERE ROWID - "Previous ROWID" > 1;
