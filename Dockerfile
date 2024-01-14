# ehough/docker-kodi - Dockerized Kodi with audio and video.
#
# https://github.com/ehough/docker-kodi
# https://hub.docker.com/r/erichough/kodi/
#
# Copyright 2018-2021 - Eric Hough (eric@tubepress.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM ubuntu:latest

# https://github.com/ehough/docker-nfs-server/pull/3#issuecomment-387880692
ARG DEBIAN_FRONTEND=noninteractive

# install the team-xbmc ppa
#RUN apt-get update                                                        && \
#                                                                            \
#       apt-get install -y --no-install-recommends                               \
#       gnupg software-properties-common                                      && \
#       add-apt-repository ppa:team-xbmc/ppa                                  && \
#       apt-get -y purge software-properties-common                           && \
#       apt-get -y --purge autoremove                                         && \
#       rm -rf /var/lib/apt/lists/*

ARG KODI_EXTRA_PACKAGES=

# besides kodi, we will install a few extra packages:
#  - ca-certificates              allows Kodi to properly establish HTTPS connections
#  - kodi-eventclients-kodi-send  allows us to shut down Kodi gracefully upon container termination
#  - kodi-game-libretro           allows Kodi to utilize Libretro cores as game add-ons (not available in ubuntu jami repo)
#  - kodi-inputstream-*           input stream add-ons
#  - kodi-peripheral-*            enables the use of gamepads, joysticks, game controllers, etc.
#  - locales                      additional spoken language support (via x11docker --lang option)
#  - pulseaudio                   in case the user prefers PulseAudio instead of ALSA
#  - tzdata                       necessary for timezone selection
#  - va-driver-all                the full suite of drivers for the Video Acceleration API (VA API)
#  - mesa-utils, mesa-utils-extra suggested by x11docker for hardware video acceleration
#  - kodi-game-libretro-*         Libretro cores (REMOVED AFTER DEPRECATION)
#  - kodi-pvr-*                   PVR add-ons (REMOVED AFTER DEPRECATION)
#  - kodi-screensaver-*           additional screensavers (REMOVED AFTER DEPRECATION)
#  - kodi-repository-kodi         official kodi add-on repository
#  - python3, python3-pycryptodome        used by netflix addon
RUN packages="                                               \
                                                             \
        ca-certificates                                          \
        kodi                                                     \
        kodi-eventclients-kodi-send                              \
#       kodi-game-libretro                                       \
        kodi-inputstream-adaptive                                \
        kodi-inputstream-rtmp                                    \
        kodi-peripheral-joystick                                 \
        kodi-peripheral-xarcade                                  \
        kodi-repository-kodi                                     \
        locales                                                  \
        python3                                                  \
        python3-pycryptodome                                     \
        pulseaudio                                               \
        tzdata                                                   \
        va-driver-all                                            \
        mesa-utils                                               \
        mesa-utils-extra                                         \
        ${KODI_EXTRA_PACKAGES}"                               && \
                                                             \
        apt-get update                                        && \
        apt-get install -y --no-install-recommends $packages  && \
        apt-get -y --purge autoremove                         && \
        rm -rf /var/lib/apt/lists/*

# setup entry point
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
