<?php
	require("mysqlconnection.php");
	//above file must include a definition for the variable $mysqli
	
	$url  = 'http://api.kingdomsatwar.com/game/logging/guild_war_log/?game_id=1&war_id=' . $_GET['warid'];
	$path = strval($_GET['warid']);
	$fp = fopen($path, 'w+');
	if($fp===false){echo "<br>Could not open file";}
	else{
	$ch = curl_init($url);
	curl_setopt($ch, CURLOPT_FILE, $fp);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
	$data = curl_exec($ch);
	curl_close($ch);
	fclose($fp);
	}

	if($mysqli->connect_error)
	{
		die("$mysqli->connect_errno: $mysqli->connect_error");
	}else{
		 echo "Success<br/>";
		}
	$maketable="CREATE TABLE `". strval($_GET['warid']) ."` (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	timestampvalue TIME,
	acting_player VARCHAR(40),
	acting_player_troops INT,
	acting_player_troops_percentage VARCHAR(4),
	acting_player_spies INT,
	acting_player_spies_percentage VARCHAR(4),
	defending_player VARCHAR(40),
	defending_player_troops INT,
	defending_player_troops_percentage VARCHAR(4),
	defending_player_spies INT,
	defending_player_spies_percentage VARCHAR(4),
	result boolean,
	type INT,
	ko INT)";
	if($mysqli->query($maketable)===TRUE){
		echo "Table created</br>";
		unset($cmdreturn);
		exec("./logreader < " . strval($_GET['warid']) . " | ./translate",$cmdreturn);
		$sqlvalues = implode($cmdreturn);
		//echo $sqlvalues;
		if($mysqli->query("INSERT INTO `" . strval($_GET['warid']) . "` (
			timestampvalue,
			acting_player,
			acting_player_troops,
			acting_player_troops_percentage,
			acting_player_spies,
			acting_player_spies_percentage,
			defending_player,
			defending_player_troops,
			defending_player_troops_percentage,
			defending_player_spies,
			defending_player_spies_percentage,
			result,
			type,
			ko) VALUES ".$sqlvalues)===TRUE){
				echo "Values Loaded Successfully";
			}else{ echo "broken";}
	}else{
		echo "War already loaded or mysql failed<br/>";
	}
	$mysqli->close();
?>