#!/bin/bash
# vim: set noet ci pi sts=0 sw=4 ts=4 :
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
