from sqlalchemy.orm import Session
from sqlalchemy import Column, Date, Integer, String, Time, create_engine, text
from sqlalchemy.dialects.mssql import UNIQUEIDENTIFIER
from sqlalchemy.orm import DeclarativeBase

url = r"mssql+pyodbc://CNYZ48:password@15-2-441-13\CNYZ48/User_Actions?driver=ODBC+Driver+17+for+SQL+Server&Encrypt=yes&TrustServerCertificate=yes&PersistSecurityInfo=no&Pooling=no&MultipleActiveResultSets=no"

s1 = create_engine(url)
s2 = create_engine(url)
s3 = create_engine(url)
s4 = create_engine(url)
s5 = create_engine(url)
s6 = create_engine(url)
s7 = create_engine(url)
s8 = create_engine(url)
s9 = create_engine(url)
s10= create_engine(url)
s11= create_engine(url)
s12= create_engine(url)

engine_list = [s1 ,s2, s3, s4, s5, s6 ,s7 ,s8 ,s9 ,s10, s11, s12]


class Base(DeclarativeBase):
    pass

class User_Logs(Base):
    __tablename__ = "User_Logs"
    id = Column(UNIQUEIDENTIFIER, primary_key=True, default=text("NEWID()"))
    username = Column(String, nullable=False)
    user_action = Column(String, nullable=False)
    action_date = Column(Date, nullable=False)
    action_time = Column(Time, nullable=False)
    action_result = Column(String, nullable=False)

Base.metadata.create_all(bind=s1)
Base.metadata.create_all(bind=s2)
Base.metadata.create_all(bind=s3)
Base.metadata.create_all(bind=s4)
Base.metadata.create_all(bind=s5)
Base.metadata.create_all(bind=s6)
Base.metadata.create_all(bind=s7)
Base.metadata.create_all(bind=s8)
Base.metadata.create_all(bind=s9)
Base.metadata.create_all(bind=s10)
Base.metadata.create_all(bind=s11)
Base.metadata.create_all(bind=s12)


def inputt(engine:str, input_data:User_Logs):
    with Session(autoflush=False, bind=engine) as db:
        db.add(input_data)
        db.commit()

def sendto_shard(input_data:User_Logs, memory):
    inputt(engine=engine_list[memory], input_data = input_data)
    print(f"bd {memory+1}")
    memory = (memory + 1) % 12
    return memory


def main():
    input_data = User_Logs(username = "sen", user_action = "DELETE", action_date = "2025-01-01", action_time = "00:00:00", action_result = "OK")
    memory = 0
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)
    memory = sendto_shard(input_data, memory=memory)    


if __name__ == "__main__":
    main()