#!/bin/bash
version=$(curl --silent "https://api.steamcmd.net/v1/info/2394010" | jq '.data."2394010".depots.branches.public.buildid' -r)
currentversion=$(cat currentversion)
echo "currentversion:$currentversion version:$version"
if [[ -z "${version}" ]]; then
    exit
fi
echo "$version" >currentversion
if [[ "$currentversion" == "$version" ]]; then
    exit
fi
git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git add currentversion
git commit -a -m "Auto Update Palworld to buildid: $version"
git tag -f latest
git push
git push origin --tags -f
