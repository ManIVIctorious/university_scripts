#!/bin/bash

weighting_mode_A=$1
weighting_mode_B=$2

output_file=${3:-constructed_combination_101+102_hess_01}

mode_A=${4:-constructed_mode_101}
mode_B=${5:-constructed_mode_102}
masses=${6:-../../freq-opt/masses}

if [ $# -lt 2 ]; then
    cat << EOF
    Usage: $0 weighting_mode_A weighting_mode_B [output-file] [mode_A] [mode_B] [masses]
    
    The default values are:
        output_file = constructed_combination_101+102_hess_01
        mode_A      = constructed_mode_101
        mode_B      = constructed_mode_102
        masses      = ../../freq-opt/masses
EOF
exit
fi

# combine the two original modes
#   break the two modes down to two columns
#   perform weighted addition of the two columns and put out form of x,y,z columns
paste $mode_A $mode_B |
awk '{printf "% 20.14lf\t% 20.14lf\n% 20.14lf\t% 20.14lf\n% 20.14lf\t% 20.14lf\n", $1, $5, $2, $6, $3, $7}' |
awk '{printf "\t% 20.14lf", $1*('$weighting_mode_A') + $2*('$weighting_mode_B'); if(NR % 3 == 0){printf "\n"}}' > tmp

# add masses to outputfile
paste tmp $masses > $output_file
rm tmp
