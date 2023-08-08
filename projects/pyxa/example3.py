# Creates a new note with a list of all events and reminders for the day.
import PyXA
from datetime import datetime, timedelta

# Activate Reminders to speed up communication of Apple Events
reminders = PyXA.Application("Reminders").activate()
notes = PyXA.Application("Notes")
calendar = PyXA.Application("Calendar")

# Get names of incomplete Reminders using a bulk method
names = reminders.reminders({ "completed": False }).name()

# Create a string listing incomplete reminders
note_text = "-- Reminders --"
for name in names:
    note_text += f"<br />Reminder: {name}"

# Get Calendar events starting within the next 2 days
start = datetime.now()
events = calendar.calendars().events().between("startDate", start, start + timedelta(days=2))

# Get event summaries (titles), start dates, and end dates using bulk methods
summaries = events.summary()
start_dates = events.start_date()
end_dates = events.end_date()

# Append the list of event information to the note text
note_text += "<br/><br />-- Events --"
for index, summary in enumerate(summaries):
    note_text += "<br />Event: " + summary + ", from " + str(start_dates[index]) + " to " + str(end_dates[index])

# Create and show the note
note = notes.new_note(f"<h1>Agenda for {start.strftime('%Y-%m-%d')}</h1>", note_text)
note.show()