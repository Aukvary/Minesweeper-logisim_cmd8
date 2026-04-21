# что нашёл для референсов
- [проект челов, которые сделали cdm8e(вроде)](https://github.com/leadpogrommer/logisim_pong)
  - у меня не получилось его запустить
- спросил у славы, лёхи, никиты про проекты, пока ничего
- проекты от дениса
  - https://github.com/denisenes/Cdm8_Tetris/tree/master
  - https://github.com/Hom4ikTop4ik/GoL-cdm/tree/main  
  - https://github.com/yusufakgull/LogisimGames/tree/main/Hangman
  - https://github.com/TheZlodziej/logisim-statki
  - https://github.com/pokitoz/Pong
  - https://github.com/some-mthfka/Digital-Snake
  - https://github.com/dtsbourg/Logisnake
  - https://github.com/RomchikkF/Digital-Platforms-Project
  - https://github.com/stevomitric/Logisim-Snake
  - https://github.com/moksyasha/PingPong_LogisimGame
  - https://github.com/Nikolay56615/Arkanoid
  - https://github.com/ferrovovan/cdm_project-spring-2024
  - https://github.com/KozlovKV/game-life
  - https://github.com/MartinCastroAlvarez/assembly-logisim-circuits
  - https://github.com/703lovelost/the-fall
  - https://github.com/PeshkovMikhail/tetris_logisim
  - https://github.com/kettleboiled/pacman
  - https://github.com/kserxd/PAC-MAN-on-logisim/tree/main

# устройство
## поле
- поле будет состоять из 8x8 ячеек
- думаю сделать ~5 карт и выбирать их рандомно, чтобы не ебаться с генерацией 
## ячейки
- какждая ячейка это циферблат, где значения 0-8 кол-во мин, F - флаг, E - мина
  - 0-2 бит отвечают за количество мин вокруг
  - 3 мина или нет
  - 4 стоит флаг или нет
  - 5 выбрана ячейка или нет
  - 6 открыта ячейка или нет
## управление
- wasd-управление, чтобы выбирать ячейку
- 2 доп кнопки, чтобы поставить флаг/открыть ячейку
- точка на циферблате будет отвечать за выбранную ячейку
- кнопка R, чтобы ресетать поле
# доп инфа
- в теории, если у нас всё запускается, то у нас 3, но Дедушка Назаров говорил, что если проект не из стандартного пулла, то +балл, также я хочу сделать приколы с прерываниями, вроде он говорил за это тоже какой-то плюс будет
