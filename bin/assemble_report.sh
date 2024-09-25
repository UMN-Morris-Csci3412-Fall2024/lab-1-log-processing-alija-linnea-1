#!/bin/bash

dir="$1"

# home=$(pwd)

cd "$dir" || exit 1

country_contents="country_contents.txt"

touch "$country_contents"

hour_contents="hour_contents.txt"

touch "$hour_contents"

username_contents="username_contents.txt"

touch "$username_contents"



grep 'data.addRow' country_dist.html > "$country_contents"

grep 'data.addRow' hours_dist.html > "$hour_contents"

grep 'data.addRow' username_dist.html > "$username_contents"

cat > "failed_login_summary.html" << EOF
<!-- ++++++++++++ START OF OVERALL HEADER +++++++++++++++++++++++++++++++ -->
<html>
<head>
	<script type='text/javascript' src='https://www.google.com/jsapi'></script>
	<script type='text/javascript'>
	google.load('visualization', '1', {'packages':['corechart', 'geochart']});

	<!-- ++++++++++++ END OF OVERALL HEADER +++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++ START OF COUNTRY HEADER +++++++++++++++++++++++++++++++ -->
	
	google.setOnLoadCallback(drawCountryDistribution);

	function drawCountryDistribution() {
		var data = new google.visualization.DataTable();
		data.addColumn('string', 'Country');
		data.addColumn('number', 'Number of failed logins');

	<!-- ++++++++++++ END OF COUNTRY HEADER +++++++++++++++++++++++++++++++ -->
$(< "$country_contents")
	<!-- ++++++++++++ START OF COUNTRY FOOTER +++++++++++++++++++++++++++++++ -->

		var chart = new google.visualization.GeoChart(document.getElementById('country_dist_div'));
		chart.draw(data, {width: 800, height: 500, title: 'Failed logins by country'});
	}

	<!-- ++++++++++++ END OF COUNTRY FOOTER +++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++ START OF HOURS HEADER +++++++++++++++++++++++++++++++ -->
	
	google.setOnLoadCallback(drawHoursDistribution);

	function drawHoursDistribution() {
		var data = new google.visualization.DataTable();
		data.addColumn('string', 'Hour of the day');
		data.addColumn('number', 'Number of failed logins');

	<!-- ++++++++++++ END OF HOURS HEADER +++++++++++++++++++++++++++++++ -->
$(< "$hour_contents")
	<!-- ++++++++++++ START OF HOURS FOOTER +++++++++++++++++++++++++++++++ -->

		var chart = new google.visualization.ColumnChart(document.getElementById('hours_dist_div'));
		chart.draw(data, {width: 800, height: 550, title: 'Failed logins by hour of the day'});
	}

	<!-- ++++++++++++ END OF HOURS FOOTER +++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++ START OF USERNAME HEADER +++++++++++++++++++++++++++++++ -->
	
	google.setOnLoadCallback(drawUsernameDistribution);

	function drawUsernameDistribution() {
		var data = new google.visualization.DataTable();
		data.addColumn('string', 'Username');
		data.addColumn('number', 'Number of failed logins');

	<!-- ++++++++++++ END OF USERNAME HEADER +++++++++++++++++++++++++++++++ -->
$(< "$username_contents")
	<!-- ++++++++++++ START OF USERNAME FOOTER +++++++++++++++++++++++++++++++ -->

		var chart = new google.visualization.PieChart(document.getElementById('username_dist_div'));
		chart.draw(data, {width: 800, height: 550, title: 'Failed logins by username'});
	}

	<!-- ++++++++++++ END OF USERNAME FOOTER +++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++ START OF OVERALL FOOTER +++++++++++++++++++++++++++++++ -->

	</script>
</head>

<body>
	<h1>Distribution of failed logins by username</h1>
	<div id='username_dist_div' style='width: 800px; height: 600px;'></div>
	<h1>Distribution of failed logins by hour of the day</h1>
	<div id='hours_dist_div' style='width: 800px; height: 600px;'></div>
	<h1>Distribution of failed logins by country of origin</h1>
	<div id='country_dist_div' style='width: 900px; height: 600px;'></div>
</body>
</html>
<!-- ++++++++++++ END OF OVERALL FOOTER +++++++++++++++++++++++++++++++ -->
EOF
