rdom() { local IFS=\>; read -d \< E C ;} ; while rdom; do if [[ $E = "Key" ]]; then echo $C ; fi ; done < $1
