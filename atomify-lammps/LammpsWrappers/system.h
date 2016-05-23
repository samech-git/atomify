#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>
#include <QVector3D>
#include <mpi.h>
#include <lammps.h>

class System : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVector3D size READ size NOTIFY sizeChanged)
    Q_PROPERTY(QVector3D origin READ origin NOTIFY originChanged)
    Q_PROPERTY(int numberOfAtoms READ numberOfAtoms NOTIFY numberOfAtomsChanged)
    Q_PROPERTY(float simulationTime READ simulationTime NOTIFY simulationTimeChanged)
    Q_PROPERTY(int timesteps READ timesteps NOTIFY timestepsChanged)
    Q_PROPERTY(Atoms* atoms READ atoms WRITE setAtoms NOTIFY atomsChanged)
    Q_PROPERTY(Regions* regions READ regions WRITE setRegions NOTIFY regionsChanged)
    Q_PROPERTY(Groups* groups READ groups WRITE setGroups NOTIFY groupsChanged)

public:
    System(class AtomifySimulator *simulator = nullptr);
    void synchronize(LAMMPS_NS::LAMMPS *lammps);
    QVector3D origin() const;
    QVector3D size() const;
    int numberOfAtoms() const;
    float simulationTime() const;
    int timesteps() const;
    class Atoms* atoms() const;
    class Regions* regions() const;
    class Groups* groups() const;

public slots:
    void setAtoms(class Atoms* atoms);
    void setRegions(class Regions* regions);
    void setGroups(class Groups* groups);

signals:
    void originChanged(QVector3D origin);
    void sizeChanged(QVector3D size);
    void numberOfAtomsChanged(int numberOfAtoms);
    void simulationTimeChanged(float simulationTime);
    void timestepsChanged(int timesteps);
    void atomsChanged(class Atoms* atoms);
    void regionsChanged(class Regions* regions);
    void groupsChanged(class Groups* groups);
private:
    class Atoms* m_atoms = nullptr;
    class Regions* m_regions = nullptr;
    class Groups* m_groups = nullptr;
    QVector3D m_origin;
    QVector3D m_size;
    int m_numberOfAtoms = 0;
    float m_simulationTime = 0;
    int m_timesteps = 0;
};

#endif // SYSTEM_H
