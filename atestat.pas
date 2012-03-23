program atestat;

 uses crt,sysutils;
 type cuvant=record
                   s: string[40];
                   end;
var subs, adj, aux, del: file of cuvant;
    w,v: cuvant;
    ge,d: string[20];                                            {declararea variabilelor}
    op: char;
     x,k, nr: integer;


     
   //********************************************************  PROCEDURA MENIU


      procedure meniu;
       begin                                             {afisarea meniului si citirea optiunii date de utilizator}
        clrscr;
         writeln('   1) Adauga');
          writeln('   2) Sterge');
           writeln('   3) Exerseaza substantiv');
            writeln('   4) Exerseaza adjectiv');
             writeln('   5) Curata');

            writeln;
            textcolor(lightmagenta);
            writeln('   Esc => Iesire');
            textcolor(lightgreen);
          op:=readkey;
       end;

      //******************************************************** ADAUGAREA CUVANTULUI IN FISIER

            function verificare(var fisier: file of cuvant):boolean;                 //* Verifica daca cuvantul introdus exista in fisier, evitand astfel introdurea a doua cuvinte identice
           var ok:boolean;
            begin
             ok:=FALSE;
              seek(fisier,0);
              while not eof(fisier) do
               begin
                read(fisier,v);
                 if (v.s=w.s) then ok:=TRUE;
                  end;
                   verificare:=ok;
             end;






                      procedure adauga;
                       var i,l:integer;                                                              //*procedura de adaugare a cuvintelor noi
                       begin                                                                       //*  in fisierul de substantive insotite de
                        i:=5;                                                                       //*  pronumele hotarat der, die das prescurtate
                                                                                                         //*  r, e, respectiv s
                        clrscr;                                                                            //*  altfel sunt adaugate in fisierul adjective
                         writeln('adauga cuvant de forma: ');
                          textcolor(lightgray);
                           writeln('cuvant_GERMANA-cuvant_ROMANA =SAU');
                            writeln('der cuv_GER-cuv_ROM =SAU= r cuv_GER-cuv_ROM');                    //*afiseaza un mesaj ajutator
                            textcolor(lightgreen);

                         repeat
                          gotoxy (1,i);
                           clreol;
                            write('=>');
                             readln(w.s);
                              l:=length(w.s);
                          if (w.s<>'') and (pos('-',w.s)<>0) and (l>3) and (w.s[1]<>'-') and (w.s[l]<>'-') then                       //*verifica daca e un cuvant valid
                               if (pos('s ', w.s)=1) or (pos('e ', w.s)=1) or (pos('r ',w.s)=1) or (pos('s ', w.s)=3) or (pos('e ', w.s)=3) or (pos('r ',w.s)=3) then
                                                                                                         begin
                                                                                                          if (pos('s ', w.s)=3) or (pos('e ', w.s)=3) or (pos('r ',w.s)=3) then
                                                                                                            delete(w.s,1,2);                                                                                                                                                                                                              //*verifica daca cuvantul va merge in fisierul substantiv
                                                                                                           if (verificare(subs)=FALSE) then
                                                                                                                                          begin
                                                                                                                                          i:=i+1;
                                                                                                                                          write(subs,w);
                                                                                                                                          end
                                                                                                          else begin
                                                                                                               goToxy (l+4,i);
                                                                                                               writeln('   cuvantuL EXISTA deja!');
                                                                                                               end;
                                                                                                         end
                               else
                                if (verificare(adj)=FALSE) then
                                                               begin
                                                                i:=i+1;
                                                                write(adj,w);
                                                               end
                                else begin
                                      gotoxy (l+4,i);
                                      writeln('   adjectivul EXISTA deja!');
                                     end
                          else begin
                            gotoxy (l+4,i);
                            write('introduceti un cuvant VALID!');
                            sound(500);
                            delay(1500);
                            gotoxy(1,i);
                            clreol;
                            end;


                            textcolor(cyan);
                                 write ('orice tasta-> CONTINUA | BACKspace-> MENIU');
                                 textcolor(lightgreen);
                           op:=readkey;
                           if op<>#8 then
                                        begin
                                         gotoxy(1,i);
                                          clreol;
                                          gotoxy(1,i+1);
                                          clreol;
                                        end;
                         until (op=#8);
                         end;
       //***************************************************************************************  EXERSAREA CUVINTELOR DIN FISIERE

              function valid(var auxiliar: file of cuvant):boolean;          //* verifica daca cuvantul a mai fost exersat
               var ok: boolean;
                begin
                 ok:=TRUE;
                 seek(auxiliar,0);
               while not eof(auxiliar) do
                begin
                 read(auxiliar,v);
                  if (w.s=v.s) then ok:=FALSE;
                end;
                 valid:=ok;
                 end;


              procedure filtru(var fisier,auxiliar: file of cuvant);                     //* nr - numarul de cuvinte exersate
               var ok: boolean;
                begin                                                                        //* functia genereaza un cuvant aleatoriu care nu a mai fost exersat
                 seek(fisier,0);
                   if (nr <= (x div 2)) then begin                                             //* x - nr de elemente din fisier
                                              k:=random(x);
                                               seek(fisier,k);
                                                read(fisier,w);
                                                 if valid(auxiliar) then                   //* procedura genereaza un cuvant valid pentru exersare
                                                                    write(auxiliar,w)
                                                 else filtru(fisier,auxiliar);
                                                 end
                   else
                         repeat
                          read(fisier,w);
                           ok:=valid(auxiliar);
                            if ok then
                                  write(auxiliar,w);
                         until ok;
             end;


       procedure exercitiu(var fisier, auxiliar: file of cuvant);                    {algoritmul de exersare al cuvintelor}
       var clrl:byte;

       begin
        reset(auxiliar);
        x:= filesize(fisier);
         clrl:=2;
         randomize;
         nr:=0;
         writeln;
        repeat
         nr:=nr+1;
         if (nr<=x) then begin

          filtru(fisier,auxiliar);
             d:=copy(w.s, 1, pos('-', w.s)-1);                      //* in d retinem cuvantul din germana
              delete(w.s, 1, pos('-', w.s));                         //* stergem cuvantul german din w.s in care ramane cuvantul in romana
               write('=> ',w.s,'-');                                   //* afisam cuvantul in romana
                readln(ge);
                  if (ge=d) then
                                begin
                                 gotoxy (length(w.s)+length(ge)+8,clrl);
                                 writeln(' *CORECT');
                                 textcolor(cyan);
                                 write ('orice tasta-> CONTINUA | BACKspace-> MENIU');
                                 textcolor(lightgreen);
                                 op:=readkey;
                                end
                  else
                       begin
                        gotoxy (length(w.s)+length(ge)+8,clrl);
                         textcolor(lightred);
                          write(d);
                           textcolor(lightgreen);
                            writeln(' ESTE RASPUNSUL CORECT');
                             textcolor(cyan);
                                 write ('orice tasta-> CONTINUA | BACKspace-> MENIU');
                                 textcolor(lightgreen);
                             op:=readkey;
                       end;
                       clrl:=clrl+1;
                       gotoxy(1,clrl);
                       clreol;
          end
          else begin
               textcolor(lightcyan);
               writeln;
               write('    NU MAI SUNT CUVINTE!...apasati orice tasta');
               textcolor(lightgreen);
               readln;
               op:=#8;
               end;
          until (op=#8);
         end;

         //****************************************************************************** STERGEAREA UNUI ELEMENT

         procedure sterge(var fisier: file of cuvant; nume_f: string[16]);

         begin

          assign(del, 'sterge.dat'); rewrite(del);



                seek(fisier, 0);

               while not eof(fisier) do
                begin
                 read(fisier, v);
                  if (w.s<>v.s) then
                   write(del, v);
                   end;

                      close(fisier);
                     erase(fisier);
                     close(del);
                   assign(fisier, 'sterge.dat');
                   rename(fisier, nume_f); reset(fisier);

          end;



                   procedure exec_sterge;
                       var i,l:integer;                                                              //*procedura de adaugare a cuvintelor noi
                       begin
                                                                                              //*  in fisierul de substantive insotite de
                        i:=5;                                                                       //*  pronumele hotarat der, die das prescurtate
                                                                                                         //*  r, e, respectiv s
                        clrscr;                                                                            //*  altfel sunt adaugate in fisierul adjective
                         writeln('Sterge un cuvant de forma: ');
                          textcolor(lightgray);
                           writeln('cuvant_GERMANA-cuvant_ROMANA =SAU');
                            writeln('der cuv_GER-cuv_ROM =SAU= r cuv_GER-cuv_ROM');                    //*afiseaza un mesaj ajutator
                            textcolor(lightgreen);

                         repeat
                          gotoxy (1,i);
                           clreol;
                            write('=>');
                             readln(w.s);
                              l:=length(w.s);
                          if (w.s<>'') and (pos('-',w.s)<>0) and (l>3) and (w.s[1]<>'-') and (w.s[l]<>'-') then                       //*verifica daca e un cuvant valid
                               if (pos('s ', w.s)=1) or (pos('e ', w.s)=1) or (pos('r ',w.s)=1) or (pos('s ', w.s)=3) or (pos('e ', w.s)=3) or (pos('r ',w.s)=3) then
                                                                                                         begin
                                                                                                          if (pos('s ', w.s)=3) or (pos('e ', w.s)=3) or (pos('r ',w.s)=3) then
                                                                                                            delete(w.s,1,2);                                                                                                                                                                                                              //*verifica daca cuvantul va merge in fisierul substantiv
                                                                                                           if verificare(subs) then
                                                                                                                                          begin
                                                                                                                                          gotoxy(l+5,i);
                                                                                                                                          i:=i+1;
                                                                                                                                          sterge(subs,'substantive.dat');
                                                                                                                                          writeln(' s-a sters');
                                                                                                                                          end;

                                                                                                         end
                               else
                                if verificare(adj) then
                                                               begin
                                                                gotoxy(l+5,i);
                                                                i:=i+1;
                                                                sterge(adj,'adjective.dat');
                                                                writeln(' s-a sters');
                                                               end
                                 else    begin
                                 gotoxy(l+6,i);
                                 writeln('cuvantul NU exista!');
                                 inc(i);
                                 end

                          else begin
                            gotoxy (l+4,i);
                            write('introduceti un cuvant VALID!');
                            sound(500);
                            delay(1500);
                            gotoxy(1,i);
                            clreol;
                            end;


                            textcolor(cyan);
                                 write ('orice tasta-> CONTINUA | BACKspace-> MENIU');
                                 textcolor(lightgreen);
                           op:=readkey;
                           if op<>#8 then
                                        begin
                                         gotoxy(1,i);
                                          clreol;
                                          gotoxy(1,i+1);
                                          clreol;
                                        end;
                         until (op=#8);
                         end;
        //*********************************************************************************AFISAREA ELEMETELOR UNUI FISIER   ?????????????
          {procedure listeaza(var fisier:cuvant);
          var j, opt, num, y: integer;
          begin
          j:=1;
                seek(fisier, 0);

               x:= filesize(fisier);

               if (x < 300) then
                gotoxy()
               while not eof(fisier) do
                begin
                 read(fisier, v);

                 writeln('  ', j, '  ', v.s);
                 inc(j);
                end;
                           }
        //************************************************************************************CURATAREA FISIERELOR

        PROCEDURE curata;
        var num: string[30]; opt: char; i: byte; ok: boolean;
            fisier: file;
        begin
             writeln('tastati NUMELE FISIERULUI pe care doriti sa-l STERGETI + .extensie: ');
             writeln;
             i:=3;
             ok:=false;
             repeat
             write('=>'); gotoxy(3, i);
             readln(num);  gotoxy(length(num)+3, i);

              if fileexists(num) then
                 begin
                  if pos('adjective',num)=1 then
                   begin
                   rewrite(adj);
                   ok:=true;
                   writeln('  radiere efectuata');
                   end;
                  if pos('substantive', num)=1 then
                   begin
                   ok:=true;
                   rewrite(subs);
                   writeln('  radiere efectuata');
                   end;
                   if pos('+', num)=1 then
                   begin
                   ok:=true;
                   rewrite(aux);
                   writeln('  radiere efectuata');
                   end;

                   if not ok then   begin
                     assign(fisier, num); rewrite(fisier);
                      writeln(  ' radiere fisier necunoscut: ', num);
                     end;
                 end

                               else writeln('    fisierul NU a fost gasit');

                   write('orice tasta-> CONTINUA | BACKspace-> MENIU');
                   opt:=readkey;
                    if opt<>#8 then begin
                     inc(i);
                     gotoxy(1, i);
                     clreol;
                     end;
                    until opt=#8;
                    end;

      //**********************************************************************************  AFISAREA MENIULUI SI CITIREA OPTIUNILOR



      procedure afisare;                                     {citirea optiunii si afisarea meniului plus executarea procedurilor in functie de optiunea citita}
       begin

        repeat
         meniu;
       case op of
            '1': begin
                   clrscr;
                   adauga;
                   afisare;
                 end;
            '2': begin
                   clrscr;
                   exec_sterge;
                   afisare;
                 end;
            '3': begin
                   clrscr;
                   exercitiu(subs,aux);
                   afisare;
                 end;
            '4': begin
                   clrscr;
                   exercitiu(adj,aux);
                   afisare;
                 end;
            '5': begin
                   clrscr;
                   curata;
                   afisare;
                 end;
            #27: begin
                  close(subs);
                  close(adj);
                  rewrite(aux);
                  close(aux);
                    halt;
                  end;
            else  begin
                        textcolor(yellow);
                        writeln;
                        writeln('    OPTIUNEA NU CORESPUNDE MENIULUI!');
                        textcolor(lightgreen);
                        sound(500);
                         delay(2000);
                         nosound;
                  end;
            end;
            afisare;
          until (op=#27);
          end;

         //*************************************************************************************     PROGRAMUL PRINCIPAL

      begin                                                         {programul principal}
           assign(subs, 'substantive.dat'); reset(subs);                  {atribuirea fisierelor}
           assign(adj, 'adjective.dat'); reset(adj);
           assign(aux, '+.dat');


           textcolor(lightgreen);
          afisare;

        end.
