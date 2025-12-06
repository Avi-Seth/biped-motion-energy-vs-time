WITH

stamp2 AS (
    SELECT CAST("Unix time stamp" AS INTEGER) AS t2
    FROM test1
    ORDER BY t2 DESC
    LIMIT 1
),

stamp1 AS (
    SELECT CAST("Unix time stamp" AS INTEGER) AS t1
    FROM test1
    ORDER BY t1
    LIMIT 1
),

time_total AS (
    SELECT (t2 - t1) AS t
    FROM stamp2, stamp1
),

avgheartrate AS (
    SELECT AVG(CAST("Heart Rate" AS INTEGER)) AS avg_rate
    FROM test1
    WHERE CAST("Heart Rate" AS INTEGER) > 0
),

distance AS (
    SELECT CAST("Cumulative distance from previous sample" AS INTEGER) AS d
    FROM test1
    ORDER BY d DESC
    LIMIT 1
),

mass AS (
    SELECT 162.2 / 2.2 AS m
),

gravity AS (
    SELECT 9.8 AS g
),

leg AS (
    SELECT 0.94 AS L
),

angle AS (
    SELECT (55*(3.1415926536/180)) AS theta
),

taylor AS (
    SELECT (theta - theta*theta*theta/6 + theta*theta*theta*theta*theta/120) AS sine
    FROM angle
),

inertia AS (
    SELECT (((0.17*m)/3)*L*L + m*L*L) AS I
    FROM mass, leg
),

ang_acc AS (
    SELECT (theta * d * d) / (4 * L * L * t * t * sine * sine) AS alpha
    FROM angle, taylor, leg, distance, time_total
)

SELECT (avg_rate * t/60) AS Heartbeats, d*(I*alpha/L + m*g*sine) / 1000 AS "Mechanical Work (kJ)"
FROM avgheartrate, time_total, leg, distance, mass, gravity, inertia, angle, taylor, ang_acc;