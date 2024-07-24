 select
datetime(history_visits.visit_time + 978307200,'unixepoch') AS "Date and Time 24HR UTC",
history_visits.title AS "Website Title",
history_items.url AS "URL",
history_items.visit_count AS "Number of visits to URL",
history_visits.id AS "History Item ID",
history_visits.redirect_source AS "History Item ID of previously visited URL",
history_visits.redirect_destination AS "History Item ID of URL visited next in sequence",
case history_visits.origin
        when 0 then "Local Device"
        when 1 then "iCloud Synced Device"
		ELSE "Contact Examiner for Further"
end AS "Local device history or Apple ecosystem?"
from history_visits
left join history_items on history_visits.history_item = history_items.id;
