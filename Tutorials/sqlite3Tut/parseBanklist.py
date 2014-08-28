import sqlite3;
from datetime import datetime, date;
 
conn = sqlite3.connect('banklist.sqlite3')
c = conn.cursor()
c.execute('drop table if exists failed_banks')
c.execute('create table failed_banks(id integer primary key autoincrement, name text, city text, state text, zip integer,acquiringinst text, close_date text, updated_date text)')
    
def mysplit (string):
    quote = False
    retval = []
    current = ""
    for char in string:
        if char == '"':
            quote = not quote
        elif char == ',' and not quote:
            retval.append(current)
            current = ""
        else:
            current += char
    retval.append(current)
    return retval
    
# Read lines from file, skipping first line
data = open("banklist.csv", "r").readlines()[1:]
for entry in data:
    # Parse values
    vals = mysplit(entry.strip())
    # Convert dates to sqlite3 standard format
    vals[5] = datetime.strptime(vals[5], "%d-%b-%y")
    vals[6] = datetime.strptime(vals[6], "%d-%b-%y")
    # Insert the row!
    print "Inserting %s..." % (vals[0])
    sql = "insert into failed_banks values(NULL, ?, ?, ?, ?, ?, ?, ?)"
    c.execute(sql, vals)
 
# Done!
conn.commit()