#!/bin/bash

ZABBIX_SERVER="192.168.126.98"

records=`cat $1 | wc -l`
echo "Sorok száma:" $records
echo ""
echo "Beolvasás és szétválogatás kezdete!"
while read -r line;
do
   epochdate=`echo "$line" | sed 's/\./-/g' | cut -f1 -d\;`
   epoch=`date -d "$epochdate" +%s`
   values=`echo $line | cut -d\; -f2- | sed 's/\,/./g'`
   line2=`echo $epoch";"$values`

   #active_energy_import_1.8.2
   value=`echo $line2 | cut -d\; -f 2`

   if [ -n "$value" ]
   then
      echo "Inverter active_energy_import_1.8.2" $epoch $value >> ./elec/import_182.txt
   fi

   #active_energy_import_1.8.1
   value=`echo $line2 | cut -d\; -f 4`

   if [ -n "$value" ]
   then
      echo "Inverter active_energy_import_1.8.1" $epoch $value >> ./elec/import_181.txt
   fi

   #active_energy_import_1.8.0
   value=`echo $line2 | cut -d\; -f 6`

   if [ -n "$value" ]
   then
      echo "Inverter active_energy_import_1.8.0" $epoch $value >> ./elec/import_180.txt
   fi

