#!/bin/bash
# na bazie sprawdzacza 'E12próbny cz. Linux Ubuntu z 2016r' sprawdza zad 'ubu_ost' z http://moodle.zs3$
# v.2
# nazwa studenta
# UWAGA w katalogu skryptu musza byc dwa pliki wzorcowe cron.wzor i users.wzor
echo 'podaj nazwę studenta'
read student
ls -d /home/ostatni/*
echo 'podaj katalog'
read kat
#funkcja czeka na klawisz
czekaj () {
read -p "Press any key to continue... " -n1 -s
}
# funkcja wycina /home/ostatnich 3-ch userów
czy_users  () {
tail -n3 /etc/passwd > /tmp/users
}
# funkcja spr konta użytkowników
czy_konta  () {
  # if plik wzorowy exists:
if [[ -e users.wzor ]]; then
   diff -s users.wzor /tmp/users > /dev/null
   #exit_status=$?
	if [[ $? -eq 0 ]]; # OK gdy exit status jest 0
	then echo 'użytkownicy_ok 3 pkty' | tee ./zad_ubu_ost$student; # wynik do nowotworzonego pliku 
	else echo 'brak_użytkowników! 0 pkt' | tee ./zad_ubu_ost$student; #pliki są różne - wynik do nowotworzonego pliku
	fi
	#exit $?
fi
}

# funkcja spr katalog domowy i wewnętrzną strukturę i prawa
czy_dom  () {
  # if katalog ~ exists:
if [[ -d /home/ostatni ]]; then
   echo 'domowy_ok 1 pkt' | tee -a ./zad_ubu_ost$student; # wynik dopisany do utworzonego uprzednio pliku 
   else echo 'domowy_brak 0 pkt' | tee -a ./zad_ubu_ost$student;
fi
}

# funkcja sprawdza strukture katalogow
czy_strukt () {
	if [[ -d $kat/oferty/przychodzace ]] && [[ -d $kat/oferty/wychodzace ]];
	then echo 'struktura_kat_ok 3 pkty' | tee -a ./zad_ubu_ost$student;
	else echo 'brak_struktury_kat! 0 pkt' | tee -a ./zad_ubu_ost$student;
	fi
}

# funkcja sprawdza strukture katalogu wspolny
czy_wsp () {
	if [[ -d $kat/wspolny ]] ;
	then echo 'wspolny_ok 1 pkt' | tee -a ./zad_ubu_ost$student;
	else echo 'brak_wspolny! 0 pkt' | tee -a ./zad_ubu_ost$student;
	fi
	ls -dl $kat/wspolny | grep t > /dev/null # bada czy nadano sticky bit
	if [[ $? -eq 0 ]]; # OK gdy exit status jest 0
	then echo 'wspolny_bit 1 pkt' | tee -a ./zad_ubu_ost$student;
	else echo 'brak_wspolny_bit! 0 pkt' | tee -a ./zad_ubu_ost$student;
	fi
}

czy_wlasc () {
	ls -dl $kat/oferty/przychodzace > /tmp/owner
	cat /tmp/owner | grep ostatni > /dev/null # gdy /home/ostatni jest właścicielem kat. wewnętrznych struktury
	if [[ $? -eq 0 ]]; # OK gdy exit status jest 0
	then echo 'struktura_prawa_ok 2 pkty' | tee -a ./zad_ubu_ost$student;
	else echo 'struktura_prawa_nok! 0 pkt' | tee -a ./zad_ubu_ost$student;
	fi
#fi
}

czy_historia () {
if [[ -e $kat/spr.txt ]] ; then # gdy istnieje sprawozdanie z historii
	echo 'sprawozdanie_istnieje 2 pkty' | tee -a ./zad_ubu_ost$student;
	else echo 'sprawozdanie_nieistnieje! 0 pkt' | tee -a ./zad_ubu_ost$student;
fi
}

czy_cron  () {
sudo crontab -lu ostatni > /tmp/cron
  # if plik wzorcowy exists:
if [[ -e cron.wzor ]] ; then
   diff -s cron.wzor /tmp/cron > /dev/null  #uwaga na pustą /home/ostatnią linię w crontab
   #exit_status=$?
	if [[ $? -eq 0 ]]; # OK gdy exit status jest 0
	then echo 'cron_ok 3 pkty' | tee -a ./zad_ubu_ost$student; # wynik do nowotworzonego pliku 
	else echo 'brak_cron! 0 pkt' | tee -a ./zad_ubu_ost$student; #pliki są różne - wynik do nowotworzonego pliku
	fi
	#exit $?
fi
}

#funkcja wykrywa nazwe skryptu
#nazwa_skrypt () {
#}

czy_skrypt  () { 
NS=`ls $kat/*.sh`
  # if skrypt exists:
if [[ -e $NS ]] ; then
	chmod a-x $NS #zabezpieczam przed uruchomieniem
	file $NS | grep shell > /dev/null #sprawdza czy NS to rzeczywiscie skrypt
		if [[ $? -eq 0 ]]; then # 
		echo 'skrypt_istnieje 3 pkty' | tee -a ./zad_ubu_ost$student; # wynik do nowotworzonego pliku 
		else echo 'brak_skryptu! 0 pkt' | tee -a ./zad_ubu_ost$student; #pliki są różne - wynik do nowotworzonego pliku
		fi
fi

}
czy_ekran () { # spr czy oddano wymagane pliki graficzne i kosztorys
if [[ -e $kat/zrzuty/ekran.png ]] ; then
	echo 'ekran_istnieje 2 pkty' | tee -a ./zad_ubu_ost$student;
	else echo 'ekran_nie_istnieje! 0 pkt' | tee -a ./zad_ubu_ost$student;
fi
}
czy_druk () { # spr czy oddano wymagane pliki graficzne i kosztorys
if [[ -e $kat/zrzuty/drukarka.png ]] ; then
	echo 'druk_istnieje 2 pkty' | tee -a ./zad_ubu_ost$student;
	else echo 'druk_nie_istnieje! 0 pkt' | tee -a ./zad_ubu_ost$student;
fi
}
czy_koszt () { # spr czy oddano wymagane pliki graficzne i kosztorys
if [[ -e $kat/kosztorys/kosztorys.ods ]] ; then
	echo 'kosztorys_istnieje 2 pkty' | tee -a ./zad_ubu_ost$student;
	else echo 'kosztorys_nie_istnieje! 0 pkt' | tee -a ./zad_ubu_ost$student;
fi
}

pkty () {
cut -d ' ' -f2 ./zad_ubu_ost$student > /tmp/pkty #wyciąga punkty z pliku
}

punkty () {
while read -r line; do
	pkt=$((pkt+$line))
done < /tmp/pkty
}

# teraz wywołanie 2-ch funkcji liczących punkty
pkty
punkty

ocena () {
ocena=0 #zerowanie oceny
max=24 #max pktów za zadanie
proc=`bc <<< "scale=2; ($pkt/$max)*100"`
iproc=${proc%.*} #zamiana float na int ze stratą ułamka
if [ $iproc -gt 95 ] ;
then ocena=5
elif [ $iproc -gt 84 ] ;
then ocena=4
elif [ $iproc -gt 77 ] ;
then ocena=3+
elif [ $iproc -gt 69 ] ;
then ocena=3 
elif [ $iproc -gt 62 ] ;
then ocena=2+
elif [ $iproc -gt 55 ] ;
then ocena=2
else ocena=1
fi
echo "max: $max" | tee ./ocena_ubu_ost$student
echo "pkty: $pkt" | tee ./oceba_ubu_ost$student
echo "proc: $iproc" | tee -a ./ocena_ubu_ost$student
echo "ocena: $ocena" | tee -a ./ocena_ubu_ost$student

}

#wywołania funkcji
czy_users
czy_konta
#czekaj
czy_dom
czy_strukt
czy_wsp
czy_wlasc
czy_historia
#czy_cron
#nazwa_skrypt
czy_skrypt
czy_ekran
czy_druk
czy_koszt
# czyta_plik
ocena
echo 'koniec sprawdzania'
cat ./zad_ubu_ost$student
echo "--koniec--"

# skrypt do sprawdzania zadania egzaminacyjnego "ubu_ost", które rozwiązuje skrypt "ubu_ostp.sh"; do zrobienia: funkcja podliczająca punkty (jest w formie skryptu "punkty.sh", możliwość zmiany nazwy badanego katalogu i przetwarzanie wsadowe na podstawie listy studentów
