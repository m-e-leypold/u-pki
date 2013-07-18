`			-*- mode: xnotes -*-

    
    u-pki: A selfcontained script to maintain a public key
    infrastructure easily
    ~~~~~~~~~~~~~~~~~~~~~
    
*   About
    -----
    
    TBD
    
    
*   Licensing
    ---------

    u-pki is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License version 3.0 as
    published by the Free Software Foundation (no later version).

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
    02110-1301 USA.
    
    
*   Sample session(s)
    -----------------    
    
    TBD: Explanations
    
**  Scenario
    
    TBD    
    
**  Setting up a new CA
    
      | $> u-pki ca new MyCA
      |
      | CA has been initialized. Now change directory to 'MyCA' and
      | run 'u-pki ca new-key <days>' to generate a new CA key which
      | is valid <days> days. Optionally link 'inbox' and 'outbox'
      | directory (e.g. to an USB stick).
      | 
      | $>
        
      | $> cd MyCA
      | $> emacs CA/CA.cnf
        
      > commonName       = <<insert email or ident text here>>
      > emailAddress     = <<insert email address here>>
      > organizationName = <<insert organization name here>>

      > commonName       = Frobnicate CA
      > emailAddress     = ca@frobnicate.no
      > organizationName = Frobnicate Inc
    
      | $> ln -s /media/usb1 inbox
      | $> ln -s /media/usb1 outbox
      | $>
    
    
      | $> u-pki ca new-key 4000

      | Generating a 2048 bit RSA private key
      | ...............+++
      | ......................................................................+++
      | writing new private key to 'CA/CA_Frobnicate-Inc_20090823_003411.key'    
    
    
**  Setting up a new organization
    
    
      | $> u-pki org new MyOrg
      |  
      | Org has been initialized.  You should now edit Org/Org.cnf.
      | Optionally link 'inbox' and 'outbox' directory (e.g. to an USB
      | stick).

      >     
      > commonName          = <<insert email or ident text here>> # only when defining entity
      > 
      > # 0.subjectAltName  = ...
      > # 1.subjectAltName  = ...
      > 
      > emailAddress        = <<insert email address here>>
      > organizationName    = <<insert organization name here>>
      > 

      > 
      > commonName          = <<insert email or ident text here>> # only when defining entity
      > 
      > # 0.subjectAltName  = ...
      > # 1.subjectAltName  = ...
      > 
      > emailAddress        = info@argoonics.no
      > organizationName    = Argoonics Foundation
      > 

      | $> ln -s /media/usb1 inbox
      | $> ln -s /media/usb1 outbox
      | $>


**    Creating a new entity and requesting keys (Org) 
    

      | $> u-pki org new-ent www
      |
      | Entity www has been created.  You should now edit
      | Ent/www.cnf.

    
    
      > 
      > commonName          = <<insert email or ident text here>> # only when defining entity
      > 
      > # 0.subjectAltName  = ...
      > # 1.subjectAltName  = ...
      >
    
      > 
      > commonName          = www.argoonics.no
      > 0.subjectAltName    = forum.argoonics.no
      > 
    
      | $> u-pki org new-req www
      | Generating a 1024 bit RSA private key
      | .......++++++
      | ........++++++
      | writing new private key to 'keys/Argoonics-Foundation_www_20090823_005242.key'
    
      | $> u-pki org send
      | $>
        
 
**  Signing keys (CA)

    
      | $> cd MyCA/

      | $> u-pki ca receive
    
      | $> u-pki ca sign-all
      | 
      | Check that the request matches the signature
      | Signature ok
      | Certificate Details:
      |         Serial Number: 1 (0x1)
      |         Validity
      |             Not Before: Aug 22 23:03:10 2009 GMT
      |             Not After : Aug 20 23:03:10 2019 GMT
      |         Subject:
      |             organizationName          = Argoonics Foundation
      |             commonName                = www.argoonics.no
      |             emailAddress              = info@argoonics.no
      |         X509v3 extensions:
      |             X509v3 Basic Constraints: 
      |                 CA:FALSE
      |             Netscape Comment: 
      |                 OpenSSL Generated Certificate
      |             X509v3 Subject Key Identifier: 
      |                 07:D3:73:06:04:A1:9C:C0:2E:C1:64:D6:9C:64:D2:E7:3A:17:B0:7F
      |             X509v3 Authority Key Identifier: 
      |                 keyid:48:EF:7C:F7:87:12:92:84:AC:DF:43:2C:54:10:97:4A:51:C7:9E:8E
      | 
      | Certificate is to be certified until Aug 20 23:03:10 2019 GMT (3650 days)
      | Sign the certificate? [y/n]:
      | 
      | 1 out of 1 certificate requests certified, commit? [y/n]y
      | Write out database with 1 new entries
      | Data Base Updated
      |
      | $>     

      | $> u-pki ca ship
      | §>


**    Receiving a certificate (Org)
    
      | $> cd MyOrg/
      | mel@daath:~/work/u-pki/unstable/TMP/MyOrg$ 
      | 
      | 
      | $> u-pki org receive
      | $>
    
      | $> ls certs/
      | Argoonics-Foundation_www_20090823_005242.crt
      | $>
