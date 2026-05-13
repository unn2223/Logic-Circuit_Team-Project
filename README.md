**시뮬레이션 결과**

게임 성공
<img width="2078" height="751" alt="image" src="https://github.com/user-attachments/assets/3a190574-e1f7-4b47-9d8f-b9f1ba0df272" />

게임 실패
<img width="1770" height="714" alt="스크린샷 2026-05-13 013524" src="https://github.com/user-attachments/assets/8f10b84b-e3a2-4387-b6fc-19c7ff0a2783" />

**DFF**

<img width="397" height="358" alt="image" src="https://github.com/user-attachments/assets/5d18c82b-03dc-4213-a529-63888ab997ba" />
<img width="397" height="358" alt="image" src="https://github.com/user-attachments/assets/b42aafc3-6448-403e-86bc-3c9bf017870c" />


<ship_register>

ship[0] DFF
D = d[0]
Q = ship[0]
S = 0
R = reset

ship[1] DFF
D = d[1]
Q = ship[1]
S = reset
R = 0

ship[2] DFF
D = d[2]
Q = ship[2]
S = 0
R = reset

<countdown_counter>

count[0] DFF
D = d[0]
Q = count[0]
S = reset
R = 0

count[1] DFF
D = d[1]
Q = count[1]
S = reset
R = 0

<obstacle_counter>
  
pattern[0] DFF
D = d[0]
Q = pattern[0]
S = 0
R = reset

pattern[1] DFF
D = d[1]
Q = pattern[1]
S = 0
R = reset

<game_control>

running DFF
D = running_d
Q = running
S = 0
R = reset

clear DFF
D = clear_d
Q = clear
S = 0
R = reset

game_over DFF
D = game_over_d
Q = game_over
S = 0
R = reset
