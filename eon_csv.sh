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


   #reactive_energy_import_3.8.0
   value=`echo $line2 | cut -d\; -f 8`

   if [ -n "$value" ]
   then
      echo "Inverter reactive_energy_import_3.8.0" $epoch $value >> ./elec/import_380.txt
   fi

   #energy_export_rate
   value=`echo $line2 | cut -d\; -f 10`

   if [ -n "$value" ]
   then
      echo "Inverter energy_export_rate" $epoch $value >> ./elec/export_rate.txt
   fi

   #energy_import_rate
   value=`echo $line2 | cut -d\; -f 12`

   if [ -n "$value" ]
   then
      echo "Inverter energy_import_rate" $epoch $value >> ./elec/import_rate.txt
   fi

   #active_energy_export_2.8.1
   value=`echo $line2 | cut -d\; -f 14`

   if [ -n "$value" ]
   then
      echo "Inverter active_energy_export_2.8.1" $epoch $value >> ./elec/export_281.txt
   fi

   #active_energy_export_2.8.0
   value=`echo $line2 | cut -d\; -f 16`

   if [ -n "$value" ]
   then
      echo "Inverter active_energy_export_2.8.0" $epoch $value >> ./elec/export_280.txt
   fi

   #active_energy_export_2.8.2
   value=`echo $line2 | cut -d\; -f 18`

   if [ -n "$value" ]
   then
      echo "Inverter active_energy_export_2.8.2" $epoch $value >> ./elec/export_282.txt
   fi

done < $1
echo "Beolvasás és szétválogatás vége!"
echo ""
mv $1 ./elec_sent/

echo "Beküldés Zabbix-ba:"
for f in ./elec/*.txt;
do
   echo "File beküldése:" $f
   zabbix_sender -z $ZABBIX_SERVER -p 10051 -i $f -T
   rm -f $f
   echo ""
done

echo "Minden rekord sikeresen beküldve Zabbix-ba! :-)"
