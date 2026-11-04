# Biped Motion: Energy vs Time

This is an independent project my teacher suggested I try over my fall 2025 school break. Question: How does the energy in bipedal motion (using heartbeats as a stand-in for oxygen consumption) compare to the mechanical work predicted by physics?

## Experiment

Recorded two walking trials (about 320 m each) with GPS watch and heart rate monitor sampling at 1 Hz. Raw data in `experiment.db` as tables `test1` and `test2`: timestamps, coordinates, altitude, heart rate, and distance per sample columns.

## Physics Equations

Walking is modeled as an inverted pendulum: Pivot leg during step is a rod where torque is applied over the foot with the body's mass swinging over it. My measurements: 
- Leg length: 0.94 m
- Step angle: 55 deg (11π/36)
- Mass: 162.2 lb (conversion to kg /2.2)

Other calculations:
- sin(theta) from 3-term Taylor series, written out by hand in SQL (accurate to about 0.0001)
- Moment of inertia of leg-body system
- Angular acceleration from total distance and time
- Mechanical Work = distance x (rotational force + gravity force)
- Mechanical work converted to kJ by /1000 for ease

## Terminal Usage

```bash
sqlite3 experiment.db < o2vwork.sql          # whole walk
sqlite3 experiment.db < o2vworkinterval.sql  # first N seconds (edit value in "limiter")
```

Results for `test1`: About 605 heartbeats and 204 kJ over 283 seconds. Trial 2: Similar work (about 201 kJ) with fewer heartbeats.

## Known limitations (found by auditing my own work)

I am aware of these and may not fix them all, since the idea was to utilize physics and the SQL practice, not perfect software:

- GPS data is unclean: the first sample of trial 1 jumps 66 m in one second while the watch got a fix, the cumulative distance column is not strictly increasing, and some cells contain " - "
- Heart rate only appears in about half the rows since the sensor reports every couple seconds
- Mass, leg length, and step angle are hardcoded into the SQL. These measurements were taken before the test, without drinking water, eating food, wearing newer clothes, or pocketing items after.
- The pendulum model is a rough approximation.

## License

GPL-3.0
