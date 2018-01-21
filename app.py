from flask import Flask, jsonify, request
from sqlalchemy import *
from sqlalchemy.orm import create_session
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
from sqlalchemy.orm import contains_eager, joinedload
from sqlalchemy.orm import relationship
import numpy as np
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

#@app.route('/post/<int:post_id>')
#def show_post(post_id):
#    # show the post with the given id, the id is an integer
#    return 'Post %d' % post_id

@app.route('/api/v1.0/precipitation')
def show_percipitation():    

    #Create and engine and get the metadata
    Base = declarative_base()
    engine = create_engine('sqlite:///hawaii.sqlite', echo=True)
    metadata = MetaData(bind=engine)

    #Reflect each database table we need to use, using metadata
    class Stations(Base):
        __table__ = Table('stations', metadata, autoload=True)
    
    class Measurements(Base):
        __table__ = Table('measurements', metadata, autoload=True)
    
    session = create_session(bind=engine)
    
    # Query the most recent 12 measurements
    qMeasurements = session.query(Measurements.date, Measurements.tobs)
    qOrderedMeasures=qMeasurements.order_by(desc(Measurements.date))
    qLast12MonthMeasures=qOrderedMeasures.filter(Measurements.date >= '2016-08-23')
    measures_list = list(np.ravel(qLast12MonthMeasures.all()))
    
    return(jsonify(measures_list))

@app.route('/api/v1.0/stations')
def show_stations():
    Base = declarative_base()
    engine = create_engine('sqlite:///hawaii.sqlite', echo=True)
    metadata = MetaData(bind=engine)

    #Reflect each database table we need to use, using metadata
    class Stations(Base):
        __table__ = Table('stations', metadata, autoload=True)
    
    class Measurements(Base):
        __table__ = Table('measurements', metadata, autoload=True)
    
    session = create_session(bind=engine)
    
    qStations = session.query(Stations.station)
    
    stations_list = list(np.ravel(qStations.all()))
    
    return(jsonify(stations_list))

@app.route('/api/v1.0/tobs')
def show_tobs():
    Base = declarative_base()
    engine = create_engine('sqlite:///hawaii.sqlite', echo=True)
    metadata = MetaData(bind=engine)

    #Reflect each database table we need to use, using metadata
    class Stations(Base):
        __table__ = Table('stations', metadata, autoload=True)
    
    class Measurements(Base):
        __table__ = Table('measurements', metadata, autoload=True)
    
    session = create_session(bind=engine)
    
    qTobsMeasurements = session.query(Measurements.station, Measurements.date, Measurements.tobs)
    qOrderedTobsMeasures=qTobsMeasurements.order_by(desc(Measurements.date))
    qLast12MonthTobsMeasures=qOrderedTobsMeasures.filter(Measurements.date >= '2016-08-23')
    tobs_list = list(np.ravel(qLast12MonthTobsMeasures.all()))
    
    return(jsonify(tobs_list))

@app.route('/api/v1.0/', methods=['GET'])
def show_temps():
    startDate=request.args.get('startdate')
    endDate=request.args.get('enddate')

    Base = declarative_base()
    engine = create_engine('sqlite:///hawaii.sqlite', echo=True)
    metadata = MetaData(bind=engine)

    #Reflect each database table we need to use, using metadata
    class Stations(Base):
        __table__ = Table('stations', metadata, autoload=True)
    
    class Measurements(Base):
        __table__ = Table('measurements', metadata, autoload=True)
    
    session = create_session(bind=engine)    
    
    if endDate is None:
        qTobsAvg = session.query(func.avg(Measurements.tobs)).filter_by(date = startDate)
        qTobsMin = session.query(func.min(Measurements.tobs)).filter_by(date = startDate)
        qTobsMax = session.query(func.max(Measurements.tobs)).filter_by(date = startDate)
 
    else:
        qTobsAvg = session.query(func.avg(Measurements.tobs)).filter(and_(Measurements.date >= startDate, Measurements.date <= endDate))
        qTobsMin = session.query(func.min(Measurements.tobs)).filter(and_(Measurements.date >= startDate, Measurements.date <= endDate))
        qTobsMax = session.query(func.max(Measurements.tobs)).filter(and_(Measurements.date >= startDate, Measurements.date <= endDate))

        
    meanTemp = qTobsAvg[0][0]
    minTemp = qTobsMin[0][0]
    maxTemp = qTobsMax[0][0]
    
    w, h = 2, 3;
    listStats = [[0 for x in range(w)] for y in range(h)]
    
    listStats[0][0]='Mean'
    listStats[0][1]=int(meanTemp)
    listStats[1][0]='Min'
    listStats[1][1]=int(minTemp)
    listStats[2][0]='Max'
    listStats[2][1]=int(maxTemp)
    
    return(jsonify(listStats))