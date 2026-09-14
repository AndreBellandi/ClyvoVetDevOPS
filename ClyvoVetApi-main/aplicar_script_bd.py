import os, oracledb

conn = oracledb.connect(
    user=os.environ["RM_FIAP"],
    password=os.environ["SENHA_FIAP"],
    dsn=f'{os.environ["HOST_FIAP"]}:{os.environ["PORTA_FIAP"]}/{os.environ["SERVICO_FIAP"]}',
)
cursor = conn.cursor()

with open("script_bd.sql", "r", encoding="utf-8") as f:
    conteudo = f.read()

comandos = [c.strip() for c in conteudo.split(";") if c.strip()]

for comando in comandos:
    try:
        cursor.execute(comando)
        print("OK:", comando[:60].replace("\n", " "), "...")
    except oracledb.DatabaseError as e:
        print("ERRO em:", comando[:60].replace("\n", " "), "->", e)

conn.commit()
cursor.close()
conn.close()
print("Script finalizado.")
