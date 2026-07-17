# Biped Motion: Energy vs Time

This is an independent project my teacher suggested I try over my fall 2025 school break, and it turned out to be way cooler than I expected. The question: when I walk somewhere, how does the energy my body spends (using heartbeats as a stand-in for oxygen consumption) compare to the mechanical work predicted by actual physics?

The twist is that the entire physics calculation is done in pure SQL. No Python, no spreadsheet. The whole biped model lives inside one query.

## The experiment

I recorded two walking trials (about 320 m each) with a GPS watch and heart rate monitor sampling at 1 Hz. The raw data lives in `experiment.db` as tables `test1` and `test2`: timestamps, coordinates, altitude, heart rate, and distance per sample.

## The physics

Walking is modeled as an inverted pendulum: the stance leg is a rod pivoting over the foot with the body's mass swinging over it. From my mass, leg length (0.94 m), and a step angle of 55 degrees, the query builds up:

- sin(theta) from a 3-term Taylor series, written out by hand in SQL (accurate to about 0.0001, I checked)
- the moment of inertia of the leg-plus-body system
- angular acceleration from total distance and time
- mechanical work = distance times (rotational force term + gravity term)

Each piece is its own CTE, so the query reads like the derivation.

## Running it

```bash
sqlite3 experiment.db < o2vwork.sql          # whole walk
sqlite3 experiment.db < o2vworkinterval.sql  # first N seconds (edit the interval CTE)
```

Results I got for `test1`: about 605 heartbeats and 204 kJ over 283 seconds. Trial 2 gave similar work (about 201 kJ) with noticeably fewer heartbeats, which is interesting on its own.

## Known limitations (found by auditing my own work)

I am aware of these and may not fix them all, since the point was the physics and the SQL practice, not shipping perfect software:

- The GPS data is messy: the first sample of trial 1 jumps 66 m in one second while the watch got a fix, the cumulative distance column is not strictly increasing, and some cells literally contain " - "
- Heart rate only appears in about half the rows since the sensor reports every couple seconds
- My mass, leg length, and step angle are hardcoded into the SQL, and `test2` requires hand-editing the table name
- The pendulum model is a rough approximation, so treat the kJ values as ballpark, not gospel

Even with all that, the project did what it was supposed to: I actually understand how a physical model of walking gets built from first principles, and I got to watch a Taylor series from precalc do a real job inside a database. Worth the break.

## License

GPL-3.0
