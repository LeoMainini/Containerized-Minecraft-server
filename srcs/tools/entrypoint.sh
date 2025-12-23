#!/bin/bash

echo "Chdir to folder"

cd /mcserver || exit

clean_up_default_data() {
	echo "Cleaning up initial default files"
	rm -rf world
}

run_server_for_setup() {
	echo "First time server execution until base files exist"
	java -jar paper.jar nogui >.server_log 2>&1 &
	SERVER_PID=$!
	while ! (cat .server_log | grep "properties"); do
		sleep 0.1s
	done
	kill -9 $SERVER_PID
	clean_up_default_data
	echo "Done"
}

init_install() {
	if [ ! -f server.properties ]; then
		wget "$SERVER_JAR_URL" -O paper.jar
		chmod +x paper.jar
		echo "eula=true" >eula.txt
		run_server_for_setup
	fi
}
apply_custom_configs() {
	motd=$(echo -n "$MOTD")
	max_players=$(echo -n "$MAX_PLAYERS")
	world_name=$(echo -n "$LEVEL_NAME")
	seed=$(echo -n "$SEED")
	server_ip=$(echo -n "$SERVER_IP")
	sim_chunks=$(echo -n "$SIM_DISTANCE")
	view_chunks=$(echo -n "$VIEW_DISTANCE")

	if [ -n "$motd" ]; then
		echo "Setting MOTD"
		line_text=$(cat server.properties | grep "motd=")
		sed -i "s/$line_text/motd=$motd/g" server.properties 		
	fi
	if [ -n "$max_players" ]; then
		echo "Setting max players"
		line_text=$(cat server.properties | grep "max-players=")
		sed -i "s/$line_text/max-players=$max_players/g" server.properties 		
	fi
	if [ -n "$world_name" ]; then
		echo "Setting world name"
		line_text=$(cat server.properties | grep "level-name=")
		sed -i "s/$line_text/level-name=$world_name/g" server.properties 		
	fi
	if [ -n "$seed" ]; then
		echo "Setting seed"
		line_text=$(cat server.properties | grep "level-seed=")
		sed -i "s/$line_text/level-seed=$seed/g" server.properties 		
	fi
	if [ -n "$server_ip" ]; then
		echo "Setting ip"
		line_text=$(cat server.properties | grep "server-ip=")
		sed -i "s/$line_text/server-ip=$server_ip/g" server.properties 		
	fi
	if [ -n "$sim_chunks" ]; then
		echo "Setting simulation chunks"
		line_text=$(cat server.properties | grep "simulation-distance=")
		sed -i "s/$line_text/simulation-distance=$sim_chunks/g" server.properties 		
	fi
	if [ -n "$view_chunks" ]; then
		echo "Setting view distance"
		line_text=$(cat server.properties | grep "view-distance=")
		sed -i "s/$line_text/view-distance=$view_chunks/g" server.properties
	fi

}

init_install
apply_custom_configs

echo "Running server with $ALLOCATED_RAM of allocated memory"
sh -c "echo java -Xms$ALLOCATED_RAM -Xmx$ALLOCATED_RAM -jar $SERVER_NAME nogui"

echo """
	#!/bin/bash
	java -Xms$ALLOCATED_RAM -Xmx$ALLOCATED_RAM -jar paper.jar nogui
""" > start.sh

chmod +x start.sh

exec "$@"
