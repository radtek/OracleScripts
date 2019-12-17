--
-- MAP_INSERTVERTEX  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.MAP_INSERTVERTEX(p1 NUMBER, p2 NUMBER, p3 NUMBER, p4 NUMBER) IS
BEGIN
insert into master.map_primitives(ID, x, y, order_rec) values(p1, p2, p3, p4);
commit;
END;

/

