#!/bin/bash

kill -9 $(cat interfere1.pid)
rm interfere1.pid

kill -9 $(cat interfere2.pid)
rm interfere2.pid


