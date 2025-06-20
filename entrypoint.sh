#!/bin/bash -e

./bin/rails db:prepare

./bin/thrust ./bin/rails server