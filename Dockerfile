###########################################################
# Dockerfile that builds a Mordhau Gameserver
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="walentinlamonos@gmail.com"

ENV STEAMAPPID=629800
ENV STEAMAPP=mordhau
ENV STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-dedicated"

COPY "etc/entry.sh" "${HOMEDIR}/entry.sh"
COPY "etc/cfg" "${STEAMAPPDIR}/cfg/"
COPY "etc/cfg" "/opt/mordhau-templates/"

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libfontconfig1 \
		libpangocairo-1.0-0 \
		libnss3 \
		libxi6 \
		libxcursor1 \
		libxss1 \
		libxcomposite1 \
		libasound2t64 \
		libxdamage1 \
		libxtst6 \
		libatk1.0-0t64 \
		libxrandr2 \
		libcurl3t64-gnutls \
		ca-certificates \
		iputils-ping \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" \
	# Clean up
	&& rm -rf /var/lib/apt/lists/*

ENV SERVER_ADMINPW="replacethisyoumadlad" \
	SERVER_PW="" \
	SERVER_NAME="My Mordhau Server" \
	SERVER_MAXPLAYERS=32 \
	SERVER_TICKRATE=60 \
	SERVER_PORT=7777 \
	SERVER_QUERYPORT=27015 \
	SERVER_BEACONPORT=15000 \
	SERVER_GAMEINI="cfg/Game.ini" \
	SERVER_ENGINEINI="cfg/Engine.ini" \
	SERVER_DEFAULTMAP="ThePit/FFA_ThePit.FFA_ThePit" \
	STEAMCMD_UPDATE_ARGS="" \
	ADDITIONAL_ARGS=""

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 27015/udp \
	15000/tcp \
	7777/udp
