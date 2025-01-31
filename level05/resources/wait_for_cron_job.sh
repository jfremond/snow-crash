#!/bin/sh -eu

sleep $(( 120 - ( $( date +%s ) % 120 ) ))
