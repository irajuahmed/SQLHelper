DECLARE @json nvarchar(max) = N'
{"data": [
            {
                "parameter": "t_2m:C",
				"regions": [
					   { 
						 "regionId":3,
						 "regionName":"GA",
						 "regionCountries":[
						    {"regionCountryName":"Kuwait"},
							{"regionCountryName":"Iran"}
						 ]					 
					   },
					   { 
						 "regionId":4,
						 "regionName":"AF",
						 "regionCountries":[
						    {"regionCountryName":"South Africa"},
							{"regionCountryName":"Sudan"}
						 ]					 
					   }
				],
                "coordinates": [
                    {
                        "lat": 51.123456,
                        "lon": -0.123456,
                        "dates": [
                            {
                                "date": "2021-11-17T12:05:00Z",
                                "value": 10.6
                            },
                            {
                                "date": "2021-11-17T13:05:00Z",
                                "value": 11.4
                            }
                        ]
                    }
                ]
            },
			{
                "parameter": "t_2m:C7",
                "regions": [
					   { 
						 "regionId":1,
						 "regionName":"SA",
						 "regionCountries":[
						    {"regionCountryName":"Bangladesh"},
							{"regionCountryName":"India"}
						 ]					 				 
					   },
					   { 
						 "regionId":2,
						 "regionName":"AS",
						 "regionCountries":[
						    {"regionCountryName":"Australia"}
						 ]					 
					   }
				],
                "coordinates": [
                    {
                        "lat": 51.123457,
                        "lon": -0.123457,
                        "dates": [
                            {
                                "date": "2021-11-17T12:05:07Z",
                                "value": 10.67
                            },
                            {
                                "date": "2021-11-17T13:05:07Z",
                                "value": 11.47
                            }
                        ]
                    }
                ]
            }
        ]
}';


SELECT
  d.parameter,
  reg.regionId,
  reg.regionName,
  regionCountry.regionCountryName,
  coord.lat,
  coord.lon,
  dates.date,
  dates.value
FROM OPENJSON(@json, '$.data')
	WITH (
		parameter nvarchar(100),
		coordinates nvarchar(max) AS JSON,
		regions nvarchar(max) AS JSON
	) d
CROSS APPLY OPENJSON(d.regions)
	WITH (
		regionId int,
		regionName nvarchar(100),
		regionCountries nvarchar(max) AS JSON
	) reg
CROSS APPLY OPENJSON(reg.regionCountries)
	WITH (
		regionCountryName nvarchar(100)
	) regionCountry

CROSS APPLY OPENJSON(d.coordinates)
	WITH (
		lat decimal(9,7),
		lon decimal(9,7),
		dates nvarchar(max) AS JSON
	) coord
CROSS APPLY OPENJSON(coord.dates)
	WITH (
		date datetimeoffset,
		value decimal(18,2)
	) dates;
