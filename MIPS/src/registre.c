#include "registre.h"

// 0->31
// at  -> 1 => ne doit pas etre lu
// -> 26-27 => ne doit pas etre lu
// gp  ->28 => pas touche
// fp  ->30 => pas touche

// ZERO -> 0 => toujours 0

// t0-9->8-15+24-25=>temporaires
// s0-7 -> 16-23 => temporaires pour sous routine
// sp  ->29 => stack pointer
// ra  ->31 => return address

// HI LO ->32-33 => resultat pour divison mult
// pc    ->34
//! total registres 32+3 pas grave si y'en a d'inutiles
register_pc *create_register()
{
    register_pc *elem = calloc(1, sizeof(register_pc));
    return elem;
}
void printf_registre(register_pc *regist)
{
    // char name[4] = {0};
    _registre* reg = regist->registre;
    for (int i = 0; i < 31; i++)
    {
        if ((*reg)[i] != 0)
        {
            //sprintf(name, "$%02d", i);
            //printf("%s:%d\n", name+1, (*reg)[i]);
            printf("$%02d:%d\n", i+1, (*reg)[i]);
        }
    }
    // if(regist->HI!=0){
        printf("HI:%d\n", regist->HI);
    // }
    // if(regist->LO!=0){
        printf("LO:%d\n", regist->LO);
    // }
}
void write_registre(register_pc *regist,FILE* file)
{
    // char name[4] = {0};
    _registre* reg = regist->registre;
    for (int i = 0; i < 31; i++)
    {
        if ((*reg)[i] != 0)
        {
            //sprintf(name, "$%02d", i);
            //printf("%s:%d\n", name+1, (*reg)[i]);
            fprintf(file,"$%02d:%d\n", i+1, (*reg)[i]);
        }
    }
    // if(regist->HI!=0){
        fprintf(file,"HI:%d\n", regist->HI);
    // }
    // if(regist->LO!=0){
        fprintf(file,"LO:%d\n", regist->LO);
    // }
}
int32_t get_register(register_pc *regist, uint8_t address)
{
    if (address == 0)
    {
        return 0;
    }
    return regist->registre[address - 1];
}
void set_pc(register_pc *regist, uint32_t value)
{
    regist->pc = value;
}
void increase_pc(register_pc *regist, uint32_t value)
{
    regist->pc += value;
}
int16_t get_pc(register_pc *regist)
{
    return regist->pc;
}
void set_register(register_pc *regist, uint8_t address,uint32_t value)
{
    if (address > 0 && address < 26)
    {
        regist->registre[address - 1] = value;
    }
}