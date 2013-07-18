
set -e
set -x
set -u

mk_ca(){
    rm -rf "$1"
    mkdir  "$1"

    rm -rf "$1"
    ./u-pki ca prep "$1"


    ( cd "$1"

      echo '
        /commonName[ 	]*=
        s/=.*/= ca@'"$1"'.org/
        /emailAddress[ 	]*=
        s/=.*/= ca@'"$1"'.org/
        /organizationName[ 	]*=
        s/=.*/= '"$1"' Organization/
        wq
        ' \
      | { sed 's|^[ 	]*||g'; sleep 1; } \
      | ed CA/CA.cnf || true


      grep -v ' *#' CA/CA.cnf | grep '<<insert'  && exit 1

      ../u-pki ca genkey 50
      ln -sf ../SHIPDIR inbox
      ln -sf ../SHIPDIR outbox

    )

    # XXX set CA name + CN
}

mk_org(){
    rm -rf "$1"
    ./u-pki org new "$1"

    ( cd "$1"

      echo '
        /emailAddress[ 	]*=
        s/=.*/= org@'"$1"'.org/
        1
        /organizationName[ 	]*=
        s/=.*/= '"$1"' Organization/
        wq
        ' \
      | { sed 's|^[ 	]*||g'; sleep 1; } \
      | ed Org/Org.cnf || true

      grep -v ' *#' Org/Org.cnf | grep '<<insert'  && exit 1

      ln -sf ../SHIPDIR inbox
      ln -sf ../SHIPDIR outbox
    )

    # XXX set org name
}

mk_ent(){
    ( cd "$1"
      ../u-pki org new-ent "$2"

      echo '
        1
        /commonName[ 	]*=
        s/=.*/= '"$2"'.'"$1"'.org/
        1
        /emailAddress[ 	]*=
        s/=.*/= '"$2"'@ents.'"$1"'.org/
        wq
        ' \
      | { sed 's|^[ 	]*||g'; sleep 1; } \
      | ed Ent/$2.cnf || true

      grep -v ' *#' Ent/$2.cnf | grep '<<insert'  && exit 1

      ../u-pki org gen-req "$2" 
      ../u-pki org send
    )
}


ca_sign(){
    ( cd "$1"
      ../u-pki ca receive 
      yes | ../u-pki ca sign-all
      ../u-pki ca ship
    )
}



org_receive(){
    ( cd "$1"
      ../u-pki org receive 
    )   
}


rm -rf SHIPDIR
mkdir SHIPDIR

mk_ca  ca1
mk_org org1
mk_org org2

mk_ent org1 www
mk_ent org1 smtp
mk_ent org2 www
mk_ent org2 groupserver

ca_sign ca1

org_receive org1
org_receive org2

# XXX check post conds

exit 0





